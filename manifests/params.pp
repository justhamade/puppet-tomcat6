# == Parameters:
#
# $parentdir::               Where tomcat will be installed
# $version::          The version of tomcat to install.
# $mirror::                  The apache mirror to download from.
# $users_tpl::   A tpl to use to render the conf/tomcat-users.xml file.
# $conf_tpl::    A tpl to use to render the conf/server.xml file.
# $logging_tpl:: A tpl to use to render the conf/logging.properties file.
# $setenv_tpl::         A tpl to use to render the bin/setenv.sh file.
# $tomcat_user::             The system user the tomcat process will run as.
# $jmxremote_access_tpl:: JMX remote access file tpl.
# $jmxremote_password_tpl:: JMX remote password file tpl.
# $java_home::               Java installation.
# $jvm_route::               Java JVM route for load balancing.
# $shutdown_password::       Tomcat shutdown password
# $tomcat_group::            The system group the tomcat process will run as.
# $admin_user::              The admin user for the Tomcat Manager webapp
# $admin_password::          The admin password for the Tomcat Manager webapp
#
# == Requires:
#   - Module['java']
#   - Module['Archive']
#
class tomcat6::params { 
    $parentdir              = '/usr/local'
    $version                = '6.0.35'
    $major_version          = '6'
    $mirror                 = 'http://archive.apache.org/dist/tomcat'
    $digest_string          = '171d255cd60894b29a41684ce0ff93a8'
    $users_tpl              = 'tomcat6/tomcat-users.xml.erb'
    $conf_tpl               = 'tomcat6/server.xml.erb'
    $logging_tpl            = 'tomcat6/logging.properties.erb'
    $setenv_tpl             = 'tomcat6/setenv.sh.erb'
    $jmxremote_access_tpl   = undef
    $jmxremote_password_tpl = undef
    $java_home              = '/usr/local/java'
    $jvm_route              = 'jvm1'
    $shutdown_password      = 'SHUTDOWN'
    $admin_port             = 8005
    $http_port              = 8080
    $tomcat_user            = 'tomcat'
    $tomcat_group           = 'tomcat'
    $admin_user             = 'tomcat'
    $admin_password         = 'tomcat'
}
