# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM rust:1.61 as builder

WORKDIR /usr/src/qv
COPY ./Cargo.toml .
COPY ./Cargo.lock .
COPY ./src ./src

RUN rustup component add rustfmt
RUN cargo build --release

FROM debian:bullseye-slim
RUN apt-get update 
RUN apt-get install --no-install-recommends -y ca-certificates
#RUN apt-get install -y extra-runtime-dependencies
#RUN rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/qv/target/release/qv /usr/local/bin

CMD ["qv"]