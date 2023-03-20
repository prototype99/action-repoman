FROM gentoo/portage:latest as portage

FROM gentoo/stage3:latest

COPY --from=portage /var/db/repos/gentoo /var/db/repos/gentoo

RUN echo 'CLEAN_DELAY=0' >> /etc/portage/make.conf
RUN echo 'EMERGE_WARNING_DELAY=0' >> /etc/portage/make.conf
RUN echo 'FEATURES="-ipc-sandbox -network-sandbox -pid-sandbox unknown-features-warn parallel-fetch parallel-install"' >> /etc/portage/make.conf
#RUN echo 'PYTHON_TARGETS="python3_9"' >> /etc/portage/make.conf
#RUN echo 'PYTHON_SINGLE_TARGET="python3_9"' >> /etc/portage/make.conf
RUN echo 'EMERGE_DEFAULT_OPTS="--keep-going --jobs=2 --load-average=2 --quiet-build=y --quiet-fail=y --backtrack=0"' >> /etc/portage/make.conf
RUN echo 'PORTAGE_NICENESS="20"' >> /etc/portage/make.conf
RUN echo 'PORTAGE_IONICE_COMMAND="ionice -c 3 -p \${PID}"' >> /etc/portage/make.conf

RUN mkdir -p '/etc/portage/package.mask'

RUN emerge -v sys-apps/portage
RUN emerge -v app-portage/repoman
RUN emerge -v dev-vcs/git

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
