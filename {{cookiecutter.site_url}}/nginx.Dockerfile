FROM freefeed/freefeed-react-client:freefeed_release_1.107.1 as ff-client
WORKDIR /client

FROM nginx:latest
COPY --from=ff-client /var/www/freefeed-react-client /usr/share/nginx/
