# == Define: rbenv::plugin
#
# === Variables
#
# [$install_dir]
#   This is set when you declare the rbenv class. There is no
#   need to overrite it when calling the rbenv::gem define.
#   Default: $rbenv::install_dir
#   This variable is required.
#
# [$latest]
#   This defines whether the plugin is kept up-to-date.
#   Defaults: false
#   This vaiable is optional.
#
# === Requires
#
# You will need to install the git package on the host system.
#
# === Examples
#
# rbenv::plugin { 'jamis/rbenv-gemset': }
#
# === Authors
#
# Justin Downing <justin@downing.us>
#
define rbenv::plugin(
  $install_dir = $rbenv::install_dir,
  $latest      = false,
) {
  include rbenv

  $plugin = split($name, '/') # divide plugin name into array

    $_install_ensure = $latest ? {
      true => 'latest',
      default => 'present',
    }

    vcsrepo {'install-${name}':
      ensure   => $_install_ensure,
      source   => "https://github.com/${name}.git",
      path     => "${install_dir}/plugins",
      provider => git,
      user     => $rbenv::owner,
    }
    ~>
    exec { "rbenv-permissions-${name}":
      command     => "/bin/chown -R ${rbenv::owner}:${rbenv::group} ${install_dir} && /bin/chmod -R g+w ${install_dir}",
      refreshonly => true,
    }

}
