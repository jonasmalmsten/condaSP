 FROM library/node

  WORKDIR /app
  RUN apt-get update ; apt-get install -y xsltproc emacs24-nox

  ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

  RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

  RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.2.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

  RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

  ENV PATH /opt/conda/bin:$PATH

  RUN conda install -y matplotlib pandas xlrd

#  RUN conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser

  ENV NGINX_VERSION 1.10.3-1~jessie

  RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
    && echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
       ca-certificates \
       nginx=${NGINX_VERSION} \
       nginx-module-xslt \
       nginx-module-geoip \
       nginx-module-image-filter \
       nginx-module-perl \
       nginx-module-njs \
       gettext-base \
    && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
  RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

  RUN npm install -y xmlhttprequest btoa

  ENTRYPOINT [ "/usr/bin/tini", "--" ]

  EXPOSE 80 443

  CMD ["nginx"]

  RUN conda install jupyter -y --quiet  && mkdir /opt/notebooks

  RUN mkdir -p /app/hostmapdir

#  ADD ./tools /app/tools
  ADD ./src/jupyter /app/src/jupyter

  CMD [ "/app/src/jupyter/start_jupyter.sh" ]

#  CMD [ "/bin/bash" ]
