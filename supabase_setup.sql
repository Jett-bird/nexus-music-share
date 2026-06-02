-- Run this in Supabase → SQL Editor

-- 1. Profiles table (extends Supabase auth.users)
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  grade text not null,
  created_at timestamptz default now()
);

-- Auto-create profile on sign-up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name, grade)
  values (
    new.id,
    new.raw_user_meta_data->>'name',
    new.raw_user_meta_data->>'grade'
  );
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. Listings table
create table if not exists public.listings (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  owner_name text not null,
  name text not null,
  cat text not null,
  price integer not null,
  contact text not null,
  description text default '',
  available boolean default true,
  created_at timestamptz default now()
);

-- 3. Row Level Security
alter table public.profiles enable row level security;
alter table public.listings enable row level security;

-- Drop existing policies first to avoid conflicts
drop policy if exists "Public profiles are viewable by everyone" on public.profiles;
drop policy if exists "Users can update their own profile" on public.profiles;
drop policy if exists "Listings are viewable by everyone" on public.listings;
drop policy if exists "Users can insert their own listings" on public.listings;
drop policy if exists "Users can update their own listings" on public.listings;
drop policy if exists "Users can delete their own listings" on public.listings;

-- Profiles policies
create policy "Public profiles are viewable by everyone"
  on public.profiles for select using (true);

create policy "Users can update their own profile"
  on public.profiles for update using (auth.uid() = id);

-- Listings policies
create policy "Listings are viewable by everyone"
  on public.listings for select using (true);

create policy "Users can insert their own listings"
  on public.listings for insert with check (auth.uid() = user_id);

create policy "Users can update their own listings"
  on public.listings for update using (auth.uid() = user_id);

create policy "Users can delete their own listings"
  on public.listings for delete using (auth.uid() = user_id);
