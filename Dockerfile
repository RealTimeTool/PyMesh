FROM https://quay.io/repository/fenicsproject/base:latest

RUN apt-get -qq update && \
    apt-get -y --with-new-pkgs \
        -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get -y install curl && \
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get -y install \
        bison \
        ccache \
        cmake \
        doxygen \
        flex \
        g++ \
        gfortran \
        git \
        git-lfs \
        graphviz \
        libboost-filesystem-dev \
        libboost-iostreams-dev \
        libboost-math-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libboost-thread-dev \
        libboost-timer-dev \
        libeigen3-dev \
        libfreetype6-dev \
        liblapack-dev \
        libmpich-dev \
        libopenblas-dev \
        libpcre3-dev \
        libpng12-dev \
        libhdf5-mpich-dev \
        libgmp-dev \
        libcln-dev \
        libmpfr-dev \
        libgmp-dev \
        libgmpxx4ldbl \
        man \
        mpich \
        nano \
        pkg-config \
        wget \
        bash-completion && \
    git lfs install && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Python2/3 based environment
RUN apt-get -qq update && \
    apt-get -y --with-new-pkgs \
        -o Dpkg::Options::="--force-confold" upgrade && \
    apt-get -y install \
        python-dev python3-dev \
        python-flufl.lock python3-flufl.lock \
        python-numpy python3-numpy \
        python-ply python3-ply \
        python-pytest python3-pytest \
        python-scipy python3-scipy \
        python-six python3-six \
        python-subprocess32 \
        python-urllib3  python3-urllib3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install setuptools
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    pip3 install --no-cache-dir setuptools && \
    python2 get-pip.py && \
    pip2 install --no-cache-dir setuptools && \
    rm -rf /tmp/*

WORKDIR /home
RUN git clone https://github.com/qnzhou/PyMesh.git
ENV PYMESH_PATH /home/PyMesh
WORKDIR $PYMESH_PATH

RUN git submodule update --init && \
rm -rf $PYMESH_PATH/third_party/build && \
rm -rf $PYMESH_PATH/build && \
mkdir -p $PYMESH_PATH/third_party/build && \
mkdir -p $PYMESH_PATH/build && \
pip install -r $PYMESH_PATH/python/requirements.txt

RUN ./setup.py build && ./setup.py install && rm -rf build third_party/build

#RUN rm -rf PyMesh
#RUN python -c "import pymesh; pymesh.test()"
