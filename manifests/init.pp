# = Class: tomcat6
#
# Install the Apache Tomcat servlet container.
#
# == Actions:
#   Install the Apache Tomcat servlet container and configure the container, users, and logging.
#
# == Requires:
#   - Module['java']
#   - Module['Archive']
#
class tomcat6 ( $parentdir               = $tomcat6::params::parentdir,
                $version                 = $tomcat6::params::version,
                $major_version           = $tomcat6::params::major_version,
                $mirror                  = $tomcat6::params::mirror,
                $digest_string           = $tomcat6::params::digest,
                $users_tpl               = $tomcat6::params::users_tpl,
                $conf_tpl                = $tomcat6::params::conf_tpl,
                $logging_tpl             = $tomcat6::params::logging_tpl,
                $setenv_tpl              = $tomcat6::params::setenv_tpl,
                $jmxremote_access_tpl    = $tomcat6::params::jmxremote_access_tpl,
                $jmxremote_password_tpl  = $tomcat6::params::jmxremote_password_tpl,
                $java_home               = $tomcat6::params::java_home,
                $jvm_route               = $tomcat6::params::jvm_route,
                $shutdown_password       = $tomcat6::params::shutdown_password,
                $admin_port              = $tomcat6::params::admin_port,
                $http_port               = $tomcat6::params::http_port,
                $tomcat_user             = $tomcat6::params::tomcat_user,
                $tomcat_group            = $tomcat6::params::tomcat_group,
                $admin_user              = $tomcat6::params::admin_user,
                $admin_password          = $tomcat6::params::admin_password
             ) inherits tomcat6::params {
    Class['java'] -> Class['tomcat6']
                    
    $basedir     = "${parentdir}/tomcat"

    user { $tomcat_user:
        ensure  => present,
        comment => "Tomcat Webserver",
        home    => "/${basedir}",
        shell   => "/bin/bash"
    }

    group { $tomcat_group:
        ensure  => present,
        require => User[$tomcat_user]
    }

    archive::download { "apache-tomcat-${version}.tar.gz":
        ensure        => present,
        url           => "${mirror}/tomcat-${major_version}/v${version}/bin/apache-tomcat-${version}.tar.gz",
        digest_string => $digest_string,
        src_target    => $parentdir,
    }

    archive::extract { "apache-tomcat-${version}":
        ensure  => present,
        target  => $parentdir,
        src_target => $parentdir,
        require => Archive::Download["apache-tomcat-${version}.tar.gz"],
        notify  => Exec["chown-apache-tomcat-${version}"],
    }

    exec { "chown-apache-tomcat-${version}":
        command => "chown -R ${tomcat_user}:${tomcat_group} ${parentdir}/apache-tomcat-${version}/*",
        unless  => "[ `stat -c %U ${parentdir}/apache-tomcat-${version}/conf` == ${tomcat_user} ]",
        require => [Archive::Extract["apache-tomcat-${version}"], User[$tomcat_user]],
        refreshonly => true,
    }

    file { $basedir: 
        ensure => link,
        target => "${parentdir}/apache-tomcat-${version}",
        require => Archive::Extract["apache-tomcat-${version}"],
    }

/*
    archive::download { "wrapper-linux-x86-${arch}-${jswrapper-version}.tar.gz":
        ensure        => present,
        url           => "http://wrapper.tanukisoftware.com/download/${jswrapper-version}/wrapper-linux-x86-${arch}-${jswrapper-version}.tar.gz"
        digest_string => $digest_string,
        src_target    => ${parentdir}/apache-tomcat-${version}",
    }
    archive::extract { "wrapper-linux-x86-${arch}-${jswrapper-version}.tar.gz":
        ensure  => present,
        target  => "${parentdir}/apache-tomcat-${version}",
        src_target => ${parentdir}/apache-tomcat-${version}",
        require => Archive::Download["wrapper-linux-x86-${arch}-${jswrapper-version}.tar.gz"],
        notify  => Exec["chown-wrapper-linux-x86-${arch}-${jswrapper-version}"],
    }
*/
    file { "${parentdir}/apache-tomcat-${version}":
        ensure => directory,
        owner  => $tomcat_user,
        require => Archive::Extract["apache-tomcat-${version}"],
    }

    file { "${parentdir}/apache-tomcat-${version}/js-wrapper":
        ensure => directory,
        owner  => $tomcat_user,
        alias  => "js-wrapper",
        require => File["${parentdir}/apache-tomcat-${version}"],
    }
    
    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/bin":
        ensure => directory,
        owner  => $tomcat_user,
        alias  => "js-wrapper-bin",
        require => File["js-wrapper"],
    }
    
    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/lib":
        ensure => directory,
        owner  => $tomcat_user,
        alias  => "js-wrapper-lib",
        require => File["js-wrapper"],
    }
    
    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/conf":
        ensure => directory,
        owner  => $tomcat_user,
        alias  => "js-wrapper-conf",
        require => File["js-wrapper"],
    }

    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/bin/wrapper":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0755,
        source => "puppet:///modules/tomcat6/bin/wrapper",
        require => File[js-wrapper],
    }

    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/lib/wrapper.jar":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0644,
        source => "puppet:///modules/tomcat6/lib/wrapper.jar",
        require => File[js-wrapper],
    }

    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/lib/libwrapper.so":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0644,
        source => "puppet:///modules/tomcat6/lib/libwrapper.so",
        require => File[js-wrapper],
    }

    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/conf/wrapper.conf":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0644,
        alias  => "jswapper-conf",
        source => "puppet:///modules/tomcat6/src/conf/wrapper.conf.in",
        require => File[js-wrapper],
    }

    file { "${parentdir}/apache-tomcat-${version}/js-wrapper/bin/tomcat":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0755,
        source => "puppet:///modules/tomcat6/src/bin/sh.script.in",
        require => File[$basedir],
    }
    
    file { "/etc/init.d/tomcat":
        ensure => link,
        target => "${parentdir}/apache-tomcat-${version}/js-wrapper/bin/tomcat",
        require => File["${parentdir}/apache-tomcat-${version}/js-wrapper/bin/tomcat"],
        force => true,
    }

    file { "${basedir}/conf/tomcat-users.xml":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0644,
        content => template($users_tpl),
        require => File[$basedir],
        notify  => Service['tomcat'],
    }

    file { "${basedir}/conf/server.xml":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0644,
        content => template($conf_tpl),
        require => File[$basedir],
        notify  => Service['tomcat'],
    }

    file { "${basedir}/conf/logging.properties":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0644,
        content => template($logging_tpl),
        require => File[$basedir],
        notify  => Service['tomcat'],
    }
    
    file { "${basedir}/bin/setenv.sh":
        ensure => present,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0755,
        content => template($setenv_tpl),
        require => File[$basedir],
        notify  => Service['tomcat'],
    }

    if $jmxremote_access_tpl != undef {
        file { "${basedir}/conf/jmxremote.access":
            ensure => present,
            owner  => $tomcat_user,
            group  => $tomcat_group,
            mode   => 0600,
            content => template($jmxremote_access_tpl),
            require => File[$basedir],
            notify  => Service['tomcat'],
        }
    }

    if $jmxremote_password_tpl != undef {
        file { "${basedir}/conf/jmxremote.password":
            ensure => present,
            owner  => $tomcat_user,
            group  => $tomcat_group,
            mode   => 0600,
            content => template($jmxremote_password_tpl),
            require => File[$basedir],
            notify  => Service['tomcat'],
        }
    }

    file { "${basedir}/conf/Catalina":
        ensure => directory,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0755,
        require => File[$basedir],
    }

    file { "${basedir}/conf/Catalina/localhost":
        ensure => directory,
        owner  => $tomcat_user,
        group  => $tomcat_group,
        mode   => 0755,
        require => File["${basedir}/conf/Catalina"],
    }

    service { 'tomcat':
        ensure  => running,
        enable => true,
        require => [File["jswapper-conf"], File["/etc/init.d/tomcat"], File["${basedir}/conf/tomcat-users.xml"]],
    }

    define overlay($tomcat_home, $tarball_path, $creates, $user) {
        exec { "unpack-tomcat-overlay-${name}":
            cwd     => $tomcat_home,
            user    => $user,
            command => "tar xjf ${tarball_path}",
            creates => $creates,
            timeout => 0,
        }
    }
}
