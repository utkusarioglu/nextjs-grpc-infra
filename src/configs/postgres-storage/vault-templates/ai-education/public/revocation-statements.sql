-- PUBLIC VIEWS
REVOKE ALL ON TABLE public."responder_domain_names" FROM "{{name}}";

REVOKE ALL ON TABLE public."responder_source_names" FROM "{{name}}";

-- PUBLIC TABLES
REVOKE ALL ON SCHEMA "public" FROM "{{name}}";

REVOKE ALL ON TABLE "public"."raw_data" FROM "{{name}}";

REVOKE ALL ON TABLE "public"."domains" FROM "{{name}}";

REVOKE ALL ON TABLE "public"."responder_domains" FROM "{{name}}";

REVOKE ALL ON TABLE "public"."responses" FROM "{{name}}";

REVOKE ALL ON TABLE "public"."sources" FROM "{{name}}";
