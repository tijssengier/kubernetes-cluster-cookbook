#
# Cookbook: kubernetes-cluster
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#

module KubernetesCookbook
  module Helpers
    include Chef::Mixin::ShellOut

    def flannel_network?
      if File.exist?('/bin/etcdctl')
        if File.exist?('/etc/kubernetes/secrets/client.srv.crt')
          cmd = shell_out!('etcdctl --cert-file=/etc/kubernetes/secrets/client.srv.crt --key-file=/etc/kubernetes/secrets/client.srv.key --ca-file=/etc/kubernetes/secrets/client.ca.crt get coreos.com/network/config | sed "/^$/d"', returns: [0, 2, 4])
          cmd.stderr.empty? && (cmd.stdout != /^Error/)
        else
          cmd = shell_out!('etcdctl get coreos.com/network/config | sed "/^$/d"', returns: [0, 2, 4])
          cmd.stderr.empty? && (cmd.stdout != /^Error/)
        end
      else
        puts 'etcdctl is not available'
      end
    end
  end
end

Chef::Resource::Execute.send(:include, KubernetesCookbook::Helpers)
