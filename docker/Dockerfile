FROM mariadb:10.1.11

ADD ramdisk_entrypoint.bsh /
RUN chmod 755 /ramdisk_entrypoint.bsh

ENTRYPOINT ["/ramdisk_entrypoint.bsh"]

CMD ["mysqld"]
