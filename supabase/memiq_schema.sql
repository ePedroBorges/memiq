create table if not exists public.profiles (
	id uuid primary key references auth.users(id) on delete cascade,
	display_name text not null default 'Jogador MEMIQ',
	avatar_id text not null default 'avatar_neon',
	banner_id text not null default 'banner_grid',
	name_style text not null default 'style_default',
	featured_achievement text not null default '',
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create table if not exists public.player_progress (
	user_id uuid primary key references auth.users(id) on delete cascade,
	best_survival int not null default 0,
	best_survival_level int not null default 1,
	survival_level int not null default 1,
	survival_xp int not null default 0,
	best_overall int not null default 0,
	games_played int not null default 0,
	survival_runs int not null default 0,
	unlocked_achievements jsonb not null default '{}'::jsonb,
	unlocked_rewards jsonb not null default '{}'::jsonb,
	selected_background text not null default 'bg_neon',
	selected_board_style text not null default 'board_classic',
	selected_sound_theme text not null default 'sound_classic',
	selected_music_theme text not null default 'music_neon_night',
	audio_muted boolean not null default false,
	visual_theme text not null default 'dark',
	display_name text not null default 'Jogador MEMIQ',
	avatar_id text not null default 'avatar_neon',
	banner_id text not null default 'banner_grid',
	name_style text not null default 'style_default',
	featured_achievement text not null default '',
	gold int not null default 0,
	diamonds int not null default 0,
	multiplayer_rating int not null default 1000,
	rank_name text not null default 'Bronze',
	multiplayer_wins int not null default 0,
	multiplayer_losses int not null default 0,
	multiplayer_loss_streak int not null default 0,
	multiplayer_win_streak int not null default 0,
	monthly_completed_phases jsonb not null default '{}'::jsonb,
	purchased_items jsonb not null default '{}'::jsonb,
	updated_at timestamptz not null default now()
);

alter table public.player_progress
	add column if not exists selected_sound_theme text not null default 'sound_classic';

alter table public.player_progress
	add column if not exists selected_music_theme text not null default 'music_neon_night';

create table if not exists public.match_history (
	id bigint generated always as identity primary key,
	user_id uuid not null references auth.users(id) on delete cascade,
	mode text not null,
	opponent_id uuid references auth.users(id) on delete set null,
	result text not null check (result in ('win', 'loss', 'draw')),
	player_score int not null default 0,
	opponent_score int not null default 0,
	rating_after int not null default 1000,
	rank_after text not null default 'Bronze',
	created_at timestamptz not null default now()
);

create table if not exists public.leaderboard_entries (
	user_id uuid primary key references auth.users(id) on delete cascade,
	display_name text not null default 'Jogador MEMIQ',
	avatar_id text not null default 'avatar_neon',
	multiplayer_rating int not null default 1000,
	rank_name text not null default 'Bronze',
	multiplayer_wins int not null default 0,
	multiplayer_losses int not null default 0,
	updated_at timestamptz not null default now()
);

create table if not exists public.friends (
	id bigint generated always as identity primary key,
	requester_id uuid not null references auth.users(id) on delete cascade,
	addressee_id uuid not null references auth.users(id) on delete cascade,
	status text not null default 'pending' check (status in ('pending', 'accepted', 'blocked')),
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	unique (requester_id, addressee_id),
	check (requester_id <> addressee_id)
);

create table if not exists public.game_seasons (
	id text primary key,
	start_date date not null,
	end_date date not null,
	label text not null,
	rewards jsonb not null default '{}'::jsonb
);

create table if not exists public.monthly_phase_sets (
	id text primary key,
	month_key text not null unique,
	phase_count int not null default 30 check (phase_count = 30),
	rewards jsonb not null default '{}'::jsonb,
	created_at timestamptz not null default now()
);

grant select, insert, update on public.profiles to authenticated;
grant select, insert, update on public.player_progress to authenticated;
grant select, insert on public.match_history to authenticated;
grant select on public.leaderboard_entries to anon, authenticated;
grant insert, update on public.leaderboard_entries to authenticated;
grant select, insert, update on public.friends to authenticated;
grant select on public.game_seasons to anon, authenticated;
grant select on public.monthly_phase_sets to anon, authenticated;

alter table public.profiles enable row level security;
alter table public.player_progress enable row level security;
alter table public.match_history enable row level security;
alter table public.leaderboard_entries enable row level security;
alter table public.friends enable row level security;
alter table public.game_seasons enable row level security;
alter table public.monthly_phase_sets enable row level security;

create policy "profiles_select_own_or_public"
on public.profiles for select
to authenticated
using (true);

create policy "profiles_insert_own"
on public.profiles for insert
to authenticated
with check ((select auth.uid()) = id);

create policy "profiles_update_own"
on public.profiles for update
to authenticated
using ((select auth.uid()) = id)
with check ((select auth.uid()) = id);

create policy "progress_select_own"
on public.player_progress for select
to authenticated
using ((select auth.uid()) = user_id);

create policy "progress_insert_own"
on public.player_progress for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "progress_update_own"
on public.player_progress for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "match_history_select_own"
on public.match_history for select
to authenticated
using ((select auth.uid()) = user_id or (select auth.uid()) = opponent_id);

create policy "match_history_insert_own"
on public.match_history for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "leaderboard_public_read"
on public.leaderboard_entries for select
to anon, authenticated
using (true);

create policy "leaderboard_insert_own"
on public.leaderboard_entries for insert
to authenticated
with check ((select auth.uid()) = user_id);

create policy "leaderboard_update_own"
on public.leaderboard_entries for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

create policy "friends_select_participants"
on public.friends for select
to authenticated
using ((select auth.uid()) = requester_id or (select auth.uid()) = addressee_id);

create policy "friends_insert_own_request"
on public.friends for insert
to authenticated
with check ((select auth.uid()) = requester_id);

create policy "friends_update_participants"
on public.friends for update
to authenticated
using ((select auth.uid()) = requester_id or (select auth.uid()) = addressee_id)
with check ((select auth.uid()) = requester_id or (select auth.uid()) = addressee_id);

create policy "seasons_public_read"
on public.game_seasons for select
to anon, authenticated
using (true);

create policy "monthly_phases_public_read"
on public.monthly_phase_sets for select
to anon, authenticated
using (true);
