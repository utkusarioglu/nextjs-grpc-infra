-- RESTRICTED TABLE PERMISSIONS
GRANT USAGE ON SCHEMA "restricted" TO "{{name}}";

GRANT SELECT ON TABLE "restricted"."responses" TO "{{name}}";

-- RESTRICTED VIEWS
GRANT SELECT ON TABLE public."responder_domain_names" TO "{{name}}";

GRANT SELECT ON TABLE public."responder_source_names" TO "{{name}}";
