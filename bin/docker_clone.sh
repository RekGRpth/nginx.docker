#!/bin/sh -eux

mkdir -p "$HOME/src"
cd "$HOME/src"
git clone -b master https://github.com/RekGRpth/nginx.git
mkdir -p "$HOME/src/nginx/modules"
cd "$HOME/src/nginx/modules"
git clone -b main https://github.com/RekGRpth/ngx_http_error_page_inherit_module.git
git clone -b main https://github.com/RekGRpth/ngx_http_include_server_module.git
git clone -b main https://github.com/RekGRpth/ngx_http_json_var_module.git
git clone -b master https://github.com/RekGRpth/echo-nginx-module.git
git clone -b master https://github.com/RekGRpth/encrypted-session-nginx-module.git
git clone -b master https://github.com/RekGRpth/form-input-nginx-module.git
git clone -b master https://github.com/RekGRpth/headers-more-nginx-module.git
git clone -b master https://github.com/RekGRpth/iconv-nginx-module.git
git clone -b master https://github.com/RekGRpth/nginx_csrf_prevent.git
git clone -b master https://github.com/RekGRpth/nginx-jwt-module.git
git clone -b master https://github.com/RekGRpth/nginx-push-stream-module.git
git clone -b master https://github.com/RekGRpth/nginx-upload-module.git
git clone -b master https://github.com/RekGRpth/nginx-upstream-fair.git
git clone -b master https://github.com/RekGRpth/nginx-uuid4-module.git
git clone -b master https://github.com/RekGRpth/ngx_brotli.git
git clone -b master https://github.com/RekGRpth/ngx_devel_kit.git
git clone -b master https://github.com/RekGRpth/ngx_http_auth_basic_ldap_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_auth_pam_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_captcha_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_evaluate_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_handlebars_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_headers_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_htmldoc_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_json_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_mustach_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_remote_passwd.git
git clone -b master https://github.com/RekGRpth/ngx_http_response_body_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_sign_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_substitutions_filter_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_time_var_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_upstream_session_sticky_module.git
git clone -b master https://github.com/RekGRpth/ngx_http_zip_var_module.git
git clone -b master https://github.com/RekGRpth/ngx_postgres.git
#git clone -b master https://github.com/RekGRpth/njs.git
git clone -b master https://github.com/RekGRpth/set-misc-nginx-module.git
git clone -b master https://github.com/RekGRpth/spnego-http-auth-nginx-module.git
if [ "$DOCKER_BUILD" = "test" ]; then
git clone -b master https://github.com/RekGRpth/nginx-tests.git
fi
