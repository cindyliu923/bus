# Taipei Bus Notify

This ruby script for Taipei bus near notify with my MacBook Terminal

## Installation

```
git clone git@github.com:cindyliu923/bus.git
```

## Setup

```
cd bus
cp .env.template .env
```
copy your [TDX](https://tdx.transportdata.tw/user/dataservice/key) CLIENT_ID & CLIENT_SECRET to `.env` file

## Usage

### run script directly for testing

```
./notify_service run
```

### run script in background

```
./notify_service start
```

### stop background script

```
./notify_service stop
```

### run script with argument

```
./notify_service run 672 1 喬治商職
./notify_service start 672 1 喬治商職
```

### see status

```
./notify_service status
```

### more command

```
./notify_service
```

#### Note

- if you can not execute `./notify_service` (got `permission denied: ./notify_service` error), change your file execute permission
```
chmod +x notify_service
```
  - [more about file permission command](https://linux.vbird.org/linux_basic/centos7/0210filepermission.php)

- script default is run with 672 1 direction near 3-5 station for 捷運六張犁站(基隆路), see notifier.rb
