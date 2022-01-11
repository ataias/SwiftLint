# SwiftLint Multi-Arch

This fork of SwiftLint contains a [build script](./script/build-multi-arch-docker-image.sh) that helps building a
multi-arch Docker image for SwiftLint. The image supports arm64, and amd64, and it uses a [multi-arch Swift image](https://hub.docker.com/repository/docker/ataias/swift).

- Docker Hub: [https://hub.docker.com/repository/docker/ataias/swiftlint](https://hub.docker.com/repository/docker/ataias/swiftlint)
- Git Repos:
  - [ataias/SwiftLint](https://github.com/ataias/SwiftLint) (fork)
  - [gitlab.com/ataias/swift-docker-multi-arch](https://gitlab.com/ataias/swift-docker-multiarch)

## Usage

```sh
docker run --volume /full/path/to/folder:/project --workdir /project ataias/swiftlint swiftlint lint
```
