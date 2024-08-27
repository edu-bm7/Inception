# Pre-requisite

- Docker-Engine, Docker-CLI and Docker Compose

    `sudo apt update && sudo apt upgrade`
    `sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`


# Docker Compose

## Why Docker Compose

Using Docker Compose offers several benefits that streamline the development, deployment, and management of containerized applications:

**Simplified control**: Docker Compose allows you to define and manage multi-container applications in a single YAML file. This simplifies the complex task of orchestrating and coordinating various services, making it easier to manage and replicate your application environment.

**Efficient collaboration**: Docker Compose configuration files are easy to share, facilitating collaboration among developers, operations teams, and other stakeholders. This collaborative approach leads to smoother workflows, faster issue resolution, and increased overall efficiency.

**Rapid application development**: Compose caches the configuration used to create a container. When you restart a service that has not changed, Compose re-uses the existing containers. Re-using containers means that you can make changes to your environment very quickly.

**Portability across environments**: Compose supports variables in the Compose file. You can use these variables to customize your composition for different environments, or different users.

**Extensive community and support**: Docker Compose benefits from a vibrant and active community, which means abundant resources, tutorials, and support. This community-driven ecosystem contributes to the continuous improvement of Docker Compose and helps users troubleshoot issues effectively.

## compose.yaml application model

Computing components of an application are defined as **services** . A **service** is an abstract concept implemented on platforms by running the same container image, and configuration, one or more times.

Services communicate with each other through **networks**. In the Compose Specification, a **network** is a platform capability abstraction to establish an IP route between containers within services connected together.

Services store and share persistent data into **volumes**. The Specification describes such a persistent data as a high-level filesystem mount with global options.

Some services require configuration data that is dependent on the runtime or platform. For this, the Specification defines a dedicated **configs** concept. From a service container point of view, configs are comparable to volumes, in that they are files mounted into the container. But the actual definition involves distinct platform resources and services, which are abstracted by this type.

A **secret** is a specific flavor of configuration data for sensitive data that should not be exposed without security considerations. Secrets are made available to services as files mounted into their containers, but the platform-specific resources to provide sensitive data are specific enough to deserve a distinct concept and definition within the Compose specification.

> **Note**

> With volumes, configs and secrets you can have a simple declaration at the top-level and then add more platform-specific information at the service level.

A project is an individual deployment of an application specification on a platform. A project's name, set with the top-level **name** attribute, is used to group resources together and isolate them from other applications or other installation of the same Compose-specified application with distinct parameters. If you are creating resources on a platform, you must prefix resource names by project and set the label `com.docker.compose.project`.

Compose offers a way for you to set a custom project name and override this name, so that the same `compose.yaml` file can be deployed twice on the same infrastructure, without changes, by just passing a distinct name.


# Wordpress requirements:
https://make.wordpress.org/hosting/handbook/server-environment/#php-extensions
WordPress core makes use of various PHP extensions when they’re available. If the preferred extension is missing WordPress will either have to do more work to do the task the module helps with or, in the worst case, will remove functionality. All the extensions are for installations with PHP >= 7.4.

The PHP extensions listed below are required for a WordPress site to work.

- json (bundled in >=8.0.0) – Used for communications with other servers and processing data in JSON format.
- One of either mysqli (bundled in >=5.0.0), or mysqlnd – Connects to MySQL for database interactions.

The PHP extensions listed below are highly recommended in order to allow WordPress to operate optimally and to maximise compatibility with many popular plugins and themes.

- curl (PHP >= 7.3 requires libcurl >= 7.15.5; PHP >= 8.0 requires libcurl >= 7.29.0) – Performs remote request operations.
- dom (requires libxml) – Used to validate Text Widget content and to automatically configure IIS7+.
- exif (requires php-mbstring) – Works with metadata stored in images.
- fileinfo (bundled in PHP) – Used to detect mimetype of file uploads.
- hash (bundled in PHP >=5.1.2) – Used for hashing, including passwords and update packages.
- igbinary – Increases performance as a drop in replacement for the standard PHP serializer.
- imagick (requires ImageMagick >= 6.2.4) – Provides better image quality for media uploads. See WP_Image_Editor for details. Smarter image resizing (for smaller images) and PDF thumbnail support, when Ghost Script is also available.
- intl (PHP >= 7.4.0 requires ICU >= 50.1) – Enable to perform locale-aware operations including but not limited to formatting, transliteration, encoding conversion, calendar operations, conformant collation, locating text boundaries and working with locale identifiers, timezones and graphemes.
- mbstring – Used to properly handle UTF8 text.
- openssl (PHP 7.1-8.0 requires OpenSSL >= 1.0.1 / < 3.0; PHP >= 8.1 requires OpenSSL >= 1.0.2 / < 4.0) – SSL-based connections to other hosts.
- pcre (bundled in PHP >= 7.0 recommended PCRE 8.10) – Increases performance of pattern matching in code searches.
- xml (requires libxml) – Used for XML parsing, such as from a third-party site.
- zip (requires libzip >= 0.11; recommended libzip >= 1.6) – Used for decompressing Plugins, Themes, and WordPress update packages.

### Configuration
https://myjeeva.com/php-fpm-configuration-101.html#pool-directives

# PID 1 init = true

The init option in Docker Compose is used to run an init process as PID 1 inside a container. This init process is responsible for handling system signals and reaping orphaned zombie processes, which are common issues in long-running containers or those that spawn multiple child processes. Here’s why you might need it:

1. Signal Forwarding:
Problem: By default, Docker containers may not correctly forward system signals (like SIGTERM) to processes inside the container. This can lead to issues when trying to gracefully stop or restart services running within the container.
Solution: An init process can properly forward these signals to child processes, ensuring that they can terminate gracefully and clean up resources correctly.
2. Reaping Zombie Processes:
Problem: In Unix-like operating systems, when a process exits, its parent process is supposed to read the exit status. If the parent process fails to do so, the terminated process remains in the process table as a "zombie." Over time, accumulating zombie processes can consume system resources and degrade performance.
Solution: An init process can automatically reap zombie processes, preventing them from accumulating and consuming resources.
3. Container Stability and Cleanup:
Problem: Without an init system, containers that spawn multiple processes may become unstable if those processes aren’t correctly managed. This can lead to memory leaks, unresponsive services, or other unpredictable behavior.
Solution: Running an init system helps to ensure that all child processes are managed correctly, improving the overall stability and reliability of the container.
When You Might Need It:
Multi-process Applications: If your container runs a service that spawns multiple child processes, such as a web server with worker processes, you would benefit from using the init option to manage these processes correctly.
Graceful Shutdown: If your application needs to handle shutdown signals properly to perform cleanup (e.g., closing database connections, saving state), an init process ensures that these signals are forwarded correctly.
Long-Running Services: For containers that are intended to run for long periods, especially in production environments, using an init process can help avoid issues with zombie processes and ensure the container runs smoothly over time

# Enter the MariaDB

    $> docker exec -it mariadb bash
    # mysql -h mariadb -u$DB_USER -p$DB_USER_PASS
    mariadb> show DATABASES;
    USE $DB_NAME;
    SHOW TABLES FROM $DB_NAME;
    SELECT * FROM wp_users;
    SELECT * FROM wp_comments;
    EXIT;
    exit

