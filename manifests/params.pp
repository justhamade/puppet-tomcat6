# == Parameters:
#
# $parentdir::               Where tomcat will be installed
# $tomcat_version::          The version of tomcat to install.
# $mirror::                  The apache mirror to download from.
# $tomcat_users_template::   A template to use to render the conf/tomcat-users.xml file.
# $tomcat_conf_template::    A template to use to render the conf/server.xml file.
# $tomcat_logging_template:: A template to use to render the conf/logging.properties file.
# $setenv_template::         A template to use to render the bin/setenv.sh file.
# $tomcat_user::             The system user the tomcat process will run as.
# $jmxremote_access_template:: JMX remote access file template.
# $jmxremote_password_template:: JMX remote password file template.
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
    $parentdir               = '/usr/local',
    $tomcat_version          = '6.0.35',
    $tomcat_major_version    = '6',
    $mirror                  = 'http://archive.apache.org/dist/tomcat',
    $digest_string           = '171d255cd60894b29a41684ce0ff93a8',
    $tomcat_users_template   = 'tomcat6/tomcat-users.xml.erb',
    $tomcat_conf_template    = 'tomcat6/server.xml.erb',
    $tomcat_logging_template = 'tomcat6/logging.properties.erb',
    $setenv_template         = 'tomcat6/setenv.sh.erb',
    $jmxremote_access_template = undef,
    $jmxremote_password_template = undef,
    $java_home               = '/usr/local/java',
    $jvm_route               = 'jvm1',
    $shutdown_password       = 'SHUTDOWN',
    $admin_port              = 8005,
    $http_port               = 8080,
    $tomcat_user             = 'root',
    $tomcat_group            = 'root',
    $admin_user              = 'tomcat',
    $admin_password          = 'tomcat'
}
