FROM mariadb:10.1.11

ADD ramdisk_entrypoint.bsh rolling_backup.bsh /
RUN chmod 755 /ramdisk_entrypoint.bsh /rolling_backup.bsh

ENTRYPOINT ["/ramdisk_entrypoint.bsh"]

CMD ["mysqld"]
