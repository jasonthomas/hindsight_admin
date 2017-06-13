FROM centos:7

ADD . /app/src/hindsight_admin/

RUN yum -y update && \
    yum -y install sudo && \

    # create the 'app' user
    groupadd -g 10001 app && \
    useradd -g app -G wheel -u 10001 -d /app app -s /bin/bash && \

    # allow app user to sudo without a password
    sed -i 's/^%wheel\tALL=(ALL)\tALL$/# %wheel\tALL=(ALL)\tALL/g' /etc/sudoers && \
    sed -i 's/^# %wheel\tALL=(ALL)\tNOPASSWD: ALL$/%wheel\tALL=(ALL)\tNOPASSWD: ALL/g' /etc/sudoers && \
    chown app:app /app -R

USER app
WORKDIR /app


RUN sudo yum -y install https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm && \
    sudo yum -y install lua-devel luarocks cmake3 make clang gcc git rpm-build sudo libstdc++-static && \
    sudo yum -y install libstdc++-static wt boost boost-devel boost-static && \
    sudo yum -y install openssl-devel libzstd-devel && \
	# boost-random boost-static boost-regex boost-thread boost-signals boost-system boost-test && \
    sudo ln -s /usr/bin/cmake3 /usr/local/bin/cmake

RUN cd /app/src && \
    git clone https://github.com/mozilla-services/lua_sandbox && \
    cd lua_sandbox && \
    mkdir release && \
    cd release && \
    cmake3 -DCMAKE_BUILD_TYPE=release .. && \
    make && \
    ctest3 && \
    cpack3 -G RPM && \
    sudo yum install -y /app/src/lua_sandbox/release/luasandbox*Linux.rpm

RUN mkdir /app/src/wt && \
    curl -s https://codeload.github.com/emweb/wt/tar.gz/3.3.4 | tar xzvf - -C /app/src/wt/ && \
    cd /app/src/wt/wt-3.3.4 && \
    mkdir build && \
    cd build && \
    cmake3 ../ && \
    make && sudo make install

    # Build hindsight
RUN cd /app/src/hindsight_admin && \
    mkdir release && \
    cd release && \
    cmake3 -DCMAKE_BUILD_TYPE=release .. && \
    make && \
    ctest3 && \
    cpack3 -G RPM && \
    sudo yum install -y /app/src/hindsight_admin/release/hindsight*Linux.rpm

    # # Setup run directory
    # cd /app && \
    # mkdir -p /app/cfg \
    #          /app/input \
    #          /app/output/input \
    #          /app/load \
    #          /app/run/input \
    #          /app/run/analysis \
    #          /app/run/output && \
    # cp /app/src/hindsight/hindsight.cfg /app/cfg/hindsight.cfg && \

    # # some extra lua libraries
    # sudo luarocks install lrexlib-pcre && \

    # cleanup
    # rm -rf /app/src && \
    # sudo yum -y remove cmake3 make clang git rpm-build c++-compiler librdkafka-devel openssl-devel postgresql-devel systemd-devel zlib-devel  && \
    # sudo yum -y autoremove && \
    # sudo yum -y clean all

# VOLUME /app/output /app/load /app/run /app/input

# CMD /usr/bin/hindsight /app/cfg/hindsight.cfg
