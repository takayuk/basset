#!/usr/bin/env ruby -Ku
# -*- encoding: utf-8 -*-
# -*- coding: utf-8 -*-

if Process.respond_to? :daemon

  Process.daemon
else
end

