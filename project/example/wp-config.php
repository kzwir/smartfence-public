<?php
define('WP_HOME', 'http://dookolamazowsza.pl');
define('WP_SITEURL', 'http://dookolamazowsza.pl');

/** 
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information by
 * visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

require_once "wp-config-zwir.php";

/**#@+
 * Authentication Unique Keys.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link http://api.wordpress.org/secret-key/1.1/ WordPress.org secret-key service}
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '= !&!+U+VI,hut1xy<Yg*s8 .M0K%j?_eEy6O[c0#Pr7??or[,/=S:5w[v7e3:A$'); /*zwir*/
define('SECURE_AUTH_KEY',  'aja0tLZ&:98_cceytbpWTv%#f>b=Xl+a0aXjPH?]_>}dh)g34vEPov0C=a]-m]T&');/*zwir*/
define('LOGGED_IN_KEY',    'V:JqRZ+E-+6;jZwaR#cTq#0n?Eh58DLBB^k6oFob7//wJF<] V6cA=o<;e_UD&Yc');/*zwir*/
define('NONCE_KEY',        'V>0)6.Bc%w.mO$`ato47=M7^0]:^*|AB9~q(%3E/3{Y5y9}rxT9o,}f -WOn#]Z-');/*zwir*/
define('AUTH_SALT',        'jVap22HuE_qUnVF8JnJ%]0_^y`4bi>+Vh)?xPkg8Za_a9S+wFuYbO :,]8pu:oWp');/*zwir*/
define('SECURE_AUTH_SALT', 'z@*6lNQ@~>|G:VVX6E1^i_4/Hq-FG<O=uY@DxNR9,!(<:>/ ^pZ#(HwR}>?R<3$@');/*zwir*/
define('LOGGED_IN_SALT',   ' l~Be(1AhhH-P:fwfsM;gBHH909cGkyc/B+qqtsG[z9PFi0S3i( ^f?4w]*wj4M7');/*zwir*/
define('NONCE_SALT',       'z|!-Rp=%Jd$HKZfbi3YYwVs4iC=k22O5nGb)Iv0z1+ApF+wk4._L<_?>i0cx_AJ7');/*zwir*/
/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'VASP6BVT2_';              /*zwir*/

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress.  A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de.mo to wp-content/languages and set WPLANG to 'de' to enable German
 * language support.
 */
define ('WPLANG', 'pl_PL');

define ('FS_METHOD', 'direct');

define('WP_DEBUG', false);
if ( ! WP_DEBUG ) {                         /*zwir*/
	ini_set('display_errors', 0);       /*zwir*/
}                                           /*zwir*/
define('DISALLOW_FILE_EDIT', true);         /*zwir*/

/* That's all, stop editing! Happy blogging. */

/** WordPress absolute path to the Wordpress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
?>