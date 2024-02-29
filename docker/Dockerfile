FROM ruby:3.2.2 AS base

RUN apt-get update && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    nodejs=\* \
    npm=\* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g yarn

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgbm-dev \
    libgtk2.0-dev \
    libnotify-dev \
    libnss3-dev \
    libx11-dev \
    libxext-dev \
    libxrender-dev

# Google Chrome のインストール
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb

# Chrome Driver のインストール
RUN CHROMEDRIVER_VERSION="$(wget -qO- https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE)" \
    && echo "Version: ${CHROMEDRIVER_VERSION}" \
    && wget -q "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip" \
    && unzip chromedriver-linux64.zip \
    && mv chromedriver-linux64/chromedriver /usr/bin/chromedriver

RUN gem install rails:7.0.7.2

WORKDIR /workspace

FROM base AS development

ENV TZ=Asia/Tokyo

COPY Gemfile* .
RUN bundle install

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
