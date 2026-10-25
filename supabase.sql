-- Run once in Supabase → SQL Editor → New query → Run.
create table if not exists public.docs (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  path text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (user_id, path)
);
alter table public.docs enable row level security;
drop policy if exists "own rows: select" on public.docs;
drop policy if exists "own rows: insert" on public.docs;
drop policy if exists "own rows: update" on public.docs;
drop policy if exists "own rows: delete" on public.docs;
create policy "own rows: select" on public.docs for select using (auth.uid() = user_id);
create policy "own rows: insert" on public.docs for insert with check (auth.uid() = user_id);
create policy "own rows: update" on public.docs for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "own rows: delete" on public.docs for delete using (auth.uid() = user_id);
alter publication supabase_realtime add table public.docs;
