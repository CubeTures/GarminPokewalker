import Toybox.Lang;

module Utils {
    function pluralize(count as Number, singular as String, plural as String) as String {
        return count + " " + (count == 1 ? singular : plural);
    }
}