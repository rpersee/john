FROM ubuntu:20.04 AS builder

ARG DEBIAN_FRONTEND=noniteractive

# john build deps
RUN apt update -q && apt install -y git build-essential libssl-dev zlib1g-dev \
    yasm pkg-config libgmp-dev libpcap-dev libbz2-dev

# opencl dev
RUN apt install -y ocl-icd-opencl-dev opencl-headers
    
# rexgen buil deps
RUN apt install -y flex libfl-dev libbison-dev cmake clang

WORKDIR /build

RUN git clone --recursive https://github.com/teeshop/rexgen.git && \
    cd rexgen && \
    sed 's/sudo//g' install.sh | sh -

RUN git clone https://github.com/openwall/john -b bleeding-jumbo john && \
    cd john/src/ && \
    ./configure --disable-native-tests CPPFLAGS='-DJOHN_SYSTEMWIDE -DJOHN_SYSTEMWIDE_EXEC="\"/usr/local/bin\"" -DJOHN_SYSTEMWIDE_HOME="\"/usr/local/share/john\""' && \
    make -s clean && make -sj4 strip

RUN mkdir -p /output/bin && \
    mkdir -p /output/share/john && \
    rm -rf /build/john/run/*.dSYM && \
    bash -c "mv /build/john/run/{john,*2john,unshadow,unique,undrop,unafs,base64conv,tgtsnarf,mkvcalcproba,genmkvpwd,calc_stat,raw2dyna,cprepair,SIPdump} /output/bin" && \
    cp -a /build/john/run/* /output/share/john && \
    bash -c "mv /output/share/john/*.{pl,py,rb} /output/share/john/{relbench,benchmark-unify,mailer,makechr} /output/bin"


FROM ubuntu:20.04

COPY --from=builder /output /usr/local

RUN apt update -q && apt install -y libssl1.1 libgomp1 \
    ocl-icd-libopencl1 opencl-headers clinfo

