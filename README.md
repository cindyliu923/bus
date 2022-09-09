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
ruby notifier.rb run
```

### run script in background

```
ruby notifier.rb start
```

### stop background script

```
ruby notifier.rb stop
```

### run script with argument

```
ruby notifier.rb run 672 1 喬治商職
ruby notifier.rb start 672 1 喬治商職
```

script default is run with 672 1 direction near 3-5 station for 博仁醫院，see notifier.rb
