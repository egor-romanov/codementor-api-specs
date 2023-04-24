-- domains table is used to store the domains in the company
create table if not exists "public"."domains" (
  "id" uuid not null default uuid_generate_v4(),
  "name" text not null,
  "created_at" timestamptz not null default now(),
  "updated_at" timestamptz not null default now(),
  "deleted_at" timestamptz null,
  primary key ("id")
);
create unique index if not exists "domains_name_key" on "public"."domains" ("name");
alter table "public"."domains" enable row level security;
create policy "domains_authenticated_policy" on "public"."domains" to "authenticated" using (true);

-- user_domains table is used to store information about the users and the domains they belong to
create table if not exists "public"."user_domains" (
  "id" uuid not null default uuid_generate_v4(),
  "user_id" uuid not null,
  "domain_id" uuid not null,
  "created_at" timestamptz not null default now(),
  "updated_at" timestamptz not null default now(),
  primary key ("id")
);
create unique index if not exists "user_domains_user_id_domain_id_key" on "public"."user_domains" ("user_id", "domain_id");
alter table "public"."user_domains" add constraint "user_domains_user_id_fkey" foreign key ("user_id") references "auth"."users" ("id") on delete cascade;
alter table "public"."user_domains" add constraint "user_domains_domain_id_fkey" foreign key ("domain_id") references "public"."domains" ("id") on delete cascade;

alter table "public"."user_domains" enable row level security;
create policy "user_domains_user_id_policy" on "public"."user_domains" for select using (auth.uid() = "user_id");

-- specs table is used to store the specs of the APIs
create table if not exists "public"."specs" (
  "id" uuid not null default uuid_generate_v4(),
  "name" text not null,
  "description" text null,
  "version" int not null,
  "schema_url" text not null,
  "domain_id" uuid not null,
  "owner_id" uuid not null,
  "created_at" timestamptz not null default now(),
  "updated_at" timestamptz not null default now(),
  "deleted_at" timestamptz null,
  primary key ("id")
);
create unique index if not exists "specs_domain_id_name_version_key" on "public"."specs" ("name", "version");
alter table "public"."specs" add constraint "specs_domain_id_fkey" foreign key ("domain_id") references "public"."domains" ("id") on delete set null;
alter table "public"."specs" add constraint "specs_owner_id_fkey" foreign key ("owner_id") references "auth"."users" ("id") on delete set null;

alter table "public"."specs" enable row level security;
create policy "specs_domain_id_select_policy" on "public"."specs" for select 
  using (
    auth.uid() in (
      select "user_id" from "public"."user_domains" as ud 
      where ud."domain_id" = "specs"."domain_id"
      )
  );
create policy "specs_domain_id_insert_policy" on "public"."specs" for insert
  with check (auth.uid() = "owner_id" and auth.uid() in (
    select ud."user_id" from "public"."user_domains" as ud 
    where ud."domain_id" = "specs"."domain_id"
    )
  );
create policy "specs_domain_id_update_policy" on "public"."specs" for update
  using (auth.uid() = "owner_id")
  with check (auth.uid() = "owner_id");
create policy "specs_domain_id_delete_policy" on "public"."specs" for delete
  using (auth.uid() = "owner_id");