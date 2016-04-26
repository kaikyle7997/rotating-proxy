FROM ubuntu:14.04
MAINTAINER Ming-Kai Jiau <kasimjm7997@gmail.com>

RUN echo 'dns-nameservers 8.8.8.8' >> /etc/network/interfaces

RUN echo 'deb http://deb.torproject.org/torproject.org trusty main' | tee /etc/apt/sources.list.d/torproject.list
#RUN echo 'deb http://deb.torproject.org/torproject.org trusty main \
#          deb http://us.archive.ubuntu.com/ubuntu vivid main universe' | tee /etc/apt/sources.list.d/torproject.list
#          deb http://deb.torproject.org/torproject.org obfs4proxy main' | tee /etc/apt/sources.list.d/torproject.list
RUN echo 'deb http://tw.archive.ubuntu.com/ubuntu/ vivid universe' | tee /etc/apt/sources.list.d/twubuntuodfs4.list

RUN gpg --keyserver keys.gnupg.net --recv 886DDD89
RUN gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

RUN echo 'deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main' | tee /etc/apt/sources.list.d/ruby.list
RUN gpg --keyserver keyserver.ubuntu.com --recv C3173AA6
RUN gpg --export 80f70e11f0f0d5f10cb20e62f5da5f09c3173aa6 | apt-key add -

RUN apt-get update && \
    apt-get install -y tor obfs4proxy polipo haproxy ruby2.1 libssl-dev wget curl build-essential zlib1g-dev libyaml-dev libssl-dev && \
    ln -s /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/libssl.so.1.0.0

RUN update-rc.d -f tor remove
RUN update-rc.d -f polipo remove

RUN echo 'ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy\n\
UseBridges 1\n\
Bridge obfs4 192.36.31.78:58535 9ABF29F60DF8DB1BE83924AA080D9CA783CC8922 cert=2aCGFv0+J4GXP6tCsvMsP+lBoipFfVSph9gAIg0AeXHA7kLjZZ9koMxiaZXJ6XqITijpVA iat-mode=0\n\
Bridge obfs4 194.132.209.35:40820 E01B120BA51DF776B1CE28FD8A47FBA37FB6926C cert=jteQoEXMoXqp5sM6RxJaE/o33JSBMV4T42JcHpp02N6lQeMZEAeJ4LqcGBBxWQd5TInDJA iat-mode=0\n\
Bridge obfs4 85.195.247.105:42501 9F548604BD5AB011F13301D843F83E1A8DA57A0D cert=I5iJp4egNJbz+20QsW02sgSBC6giNQhsbGtLATeAgzwSWdJfxvXbAY+hhWlBqmpuo+plKQ iat-mode=0\n'\
>> /etc/tor/torrc

RUN gem install excon -v 0.44.4

ADD start.rb /usr/local/bin/start.rb
RUN chmod +x /usr/local/bin/start.rb

ADD haproxy.cfg.erb /usr/local/etc/haproxy.cfg.erb

EXPOSE 5566 1936

CMD /usr/local/bin/start.rb
