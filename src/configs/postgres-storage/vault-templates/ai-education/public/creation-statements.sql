-- PUBLIC TABLES
GRANT USAGE ON SCHEMA "public" TO "{{name}}";
GRANT SELECT ON TABLE "public"."raw_data" TO "{{name}}";
GRANT SELECT ON TABLE "public"."domains" TO "{{name}}";
GRANT SELECT ON TABLE "public"."responder_domains" TO "{{name}}";
GRANT SELECT ON TABLE "public"."responses" TO "{{name}}";
GRANT SELECT ON TABLE "public"."sources" TO "{{name}}";

-- PUBLIC VIEWS
GRANT SELECT ON TABLE public."responder_domain_names" TO "{{name}}";
GRANT SELECT ON TABLE public."responder_source_names" TO "{{name}}";
