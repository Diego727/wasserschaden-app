-- Wasserschaden-App – Supabase Setup
-- Dieses Script einmal im Supabase SQL Editor ausführen.

create extension if not exists pgcrypto;

create table if not exists public.ws_damages (
  id uuid primary key default gen_random_uuid(),
  number text not null,
  name text not null,
  room text default '',
  category text default 'Sonstiges',
  status text default 'Beschädigt',
  purchase_price numeric(12,2) default 0,
  damage_amount numeric(12,2) default 0,
  purchase_date text default '',
  description text default '',
  notes text default '',
  photos jsonb not null default '[]'::jsonb,
  created_by text default '',
  created_by_user uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.ws_work (
  id uuid primary key default gen_random_uuid(),
  date date not null,
  person text not null,
  time_from time,
  time_to time,
  hours numeric(8,2) default 0,
  type text default 'Sonstiges',
  notes text default '',
  created_by_user uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Nur angemeldete Benutzer dürfen Daten sehen und ändern.
alter table public.ws_damages enable row level security;
alter table public.ws_work enable row level security;

drop policy if exists "authenticated read damages" on public.ws_damages;
drop policy if exists "authenticated insert damages" on public.ws_damages;
drop policy if exists "authenticated update damages" on public.ws_damages;
drop policy if exists "authenticated delete damages" on public.ws_damages;
create policy "authenticated read damages" on public.ws_damages for select to authenticated using (true);
create policy "authenticated insert damages" on public.ws_damages for insert to authenticated with check (true);
create policy "authenticated update damages" on public.ws_damages for update to authenticated using (true) with check (true);
create policy "authenticated delete damages" on public.ws_damages for delete to authenticated using (true);

drop policy if exists "authenticated read work" on public.ws_work;
drop policy if exists "authenticated insert work" on public.ws_work;
drop policy if exists "authenticated update work" on public.ws_work;
drop policy if exists "authenticated delete work" on public.ws_work;
create policy "authenticated read work" on public.ws_work for select to authenticated using (true);
create policy "authenticated insert work" on public.ws_work for insert to authenticated with check (true);
create policy "authenticated update work" on public.ws_work for update to authenticated using (true) with check (true);
create policy "authenticated delete work" on public.ws_work for delete to authenticated using (true);

-- Privater Foto-Bucket.
insert into storage.buckets (id, name, public)
values ('damage-photos', 'damage-photos', false)
on conflict (id) do update set public = false;

drop policy if exists "authenticated read damage photos" on storage.objects;
drop policy if exists "authenticated upload damage photos" on storage.objects;
drop policy if exists "authenticated update damage photos" on storage.objects;
drop policy if exists "authenticated delete damage photos" on storage.objects;
create policy "authenticated read damage photos" on storage.objects for select to authenticated using (bucket_id = 'damage-photos');
create policy "authenticated upload damage photos" on storage.objects for insert to authenticated with check (bucket_id = 'damage-photos');
create policy "authenticated update damage photos" on storage.objects for update to authenticated using (bucket_id = 'damage-photos') with check (bucket_id = 'damage-photos');
create policy "authenticated delete damage photos" on storage.objects for delete to authenticated using (bucket_id = 'damage-photos');

-- Realtime für beide Tabellen aktivieren, falls noch nicht aktiv.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'ws_damages'
  ) then
    alter publication supabase_realtime add table public.ws_damages;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'ws_work'
  ) then
    alter publication supabase_realtime add table public.ws_work;
  end if;
end $$;
