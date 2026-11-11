-- Melbourne Magics: database setup for Supabase.
-- Paste this whole file into Supabase > SQL Editor and click Run. Safe to run more than once.

-- 1. Tables -----------------------------------------------------------------
create table if not exists public.people (
  id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  constraint people_size check (pg_column_size(data) < 200000)
);
create table if not exists public.prefs (
  id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  constraint prefs_size check (pg_column_size(data) < 100000)
);
create table if not exists public.site (
  id text primary key,
  data jsonb not null default '{}'::jsonb
);
create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

alter table public.people enable row level security;
alter table public.prefs  enable row level security;
alter table public.site   enable row level security;
alter table public.admins enable row level security;

-- 2. Who can do what --------------------------------------------------------
-- Admins: each person can only see whether they themselves are an admin.
drop policy if exists "admins read own" on public.admins;
create policy "admins read own" on public.admins for select to authenticated
  using (user_id = auth.uid());

-- Ratings, reviews and added cafes: everyone reads; each person writes their own row;
-- admins can edit any row (to remove a bad review).
drop policy if exists "people read" on public.people;
create policy "people read" on public.people for select to anon, authenticated using (true);
drop policy if exists "people insert own" on public.people;
create policy "people insert own" on public.people for insert to authenticated
  with check (id = auth.uid());
drop policy if exists "people update own or admin" on public.people;
create policy "people update own or admin" on public.people for update to authenticated
  using (id = auth.uid() or exists (select 1 from public.admins a where a.user_id = auth.uid()))
  with check (id = auth.uid() or exists (select 1 from public.admins a where a.user_id = auth.uid()));

-- Favourites: private to each person.
drop policy if exists "prefs own" on public.prefs;
create policy "prefs own" on public.prefs for all to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- Site settings (hidden cafes): everyone reads; only admins write.
drop policy if exists "site read" on public.site;
create policy "site read" on public.site for select to anon, authenticated using (true);
drop policy if exists "site insert admin" on public.site;
create policy "site insert admin" on public.site for insert to authenticated
  with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));
drop policy if exists "site update admin" on public.site;
create policy "site update admin" on public.site for update to authenticated
  using (exists (select 1 from public.admins a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admins a where a.user_id = auth.uid()));

-- 3. Photo storage ----------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('photos', 'photos', true, 5242880, array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;

drop policy if exists "photos read" on storage.objects;
create policy "photos read" on storage.objects for select to anon, authenticated
  using (bucket_id = 'photos');
drop policy if exists "photos insert own" on storage.objects;
create policy "photos insert own" on storage.objects for insert to authenticated
  with check (bucket_id = 'photos' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "photos delete own or admin" on storage.objects;
create policy "photos delete own or admin" on storage.objects for delete to authenticated
  using (bucket_id = 'photos' and ((storage.foldername(name))[1] = auth.uid()::text
         or exists (select 1 from public.admins a where a.user_id = auth.uid())));

-- 4. Make yourself the admin -----------------------------------------------
-- After you have signed in to the website once, run this line on its own,
-- with your own email in place of the example:
--
--   insert into public.admins select id from auth.users where email = 'you@example.com';
