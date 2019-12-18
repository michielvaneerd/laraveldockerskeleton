release-live:
    test -d htdocs.new
    test ! -d htdocs.old
    mv htdocs htdocs.old && mv htdocs.new htdocs
    ln -s /opt/web/site/er-reuma-app/storage htdocs/storage
    ln -s /opt/web/site/er-reuma-app/htdocs/vendor/almasaeed2010/adminlte htdocs/public/adminlte
    cp /opt/web/php/includes/mysql/er_reuma_app.env htdocs/.env
    composer install -d htdocs
    php htdocs/artisan storage:link
    # TODO: call `php artisan migrate` as well?
    if [ -d htdocs.`date "+%Y%m%d"` ]; then rm -fr htdocs.old; else mv htdocs.old htdocs.`date "+%Y%m%d"`; fi