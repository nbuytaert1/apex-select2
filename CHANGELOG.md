Changelog
=========

####v1.0 - 12/08/2013
* initial release
* based on Select2 v3.4.1

####v1.1 - 14/08/2013
* fixed several bugs and temporarily dropped support for cascading LOVs, I'll try to re-include it in the next version

####v1.2 - 16/08/2013
* introduced cascading LOV support again ([issue #3](https://github.com/nbuytaert1/apex-select2/issues/3))

####v1.3 - 19/08/2013
* upgraded the Select2 libraries to version 3.4.2 ([issue #5](https://github.com/nbuytaert1/apex-select2/issues/5))
* fixed [issue #6](https://github.com/nbuytaert1/apex-select2/issues/6)

####v1.4 - 20/08/2013
* introduced a custom width attribute and changed the default width calculation behaviour ([issue #8](https://github.com/nbuytaert1/apex-select2/issues/8))
* fixed [issue #9](https://github.com/nbuytaert1/apex-select2/issues/9)

####v2.0 - 04/09/2013
* lowered the minimum APEX version to 4.1 ([issue #11](https://github.com/nbuytaert1/apex-select2/issues/11) - thanks to Jorge Rimblas for the help
* included drag and drop sorting in tagging mode ([issue #7](https://github.com/nbuytaert1/apex-select2/issues/7))

####v2.0.1 - 04/09/2013
* fixed [issue #12](https://github.com/nbuytaert1/apex-select2/issues/12)

####v2.0.2 - 07/09/2013
* fixed [issue #13](https://github.com/nbuytaert1/apex-select2/issues/13)

####v2.0.3 - 08/09/2013
* fixed [issue #14](https://github.com/nbuytaert1/apex-select2/issues/14)

####v2.1 - 25/10/2013
* fixed [issue #15](https://github.com/nbuytaert1/apex-select2/issues/15)
* upgraded the Select2 libraries to version 3.4.3 ([issue #17](https://github.com/nbuytaert1/apex-select2/issues/17))
* upgraded the Select2 libraries to version 3.4.4 ([issue #20](https://github.com/nbuytaert1/apex-select2/issues/20))
* introduced custom Select2 plugin events to be used in dynamic actions ([issue #21](https://github.com/nbuytaert1/apex-select2/issues/21))

####v2.2 - 29/10/2013
* reverted back to version 3.4.3 due to some bugs in 3.4.4
* new setting in tagging mode: ﻿Return Value Based on - determines whether ﻿the return value of the item is based on the display or return column ([issue #18](https://github.com/nbuytaert1/apex-select2/issues/18)) - pull request by Martin Giffy D'Souza

####v2.3 - 15/11/2013
* upgraded the Select2 libraries to version 3.4.5

####v2.3.1 - 28/03/2014
* fixed when item value is null on dropdown list and it's incorrectly detected as a form change ([issue #27](https://github.com/nbuytaert1/apex-select2/issues/27)) - pull request by Jorge Rimblas

####v2.4 - 30/03/2014
* tested Jorge Rimbas' pull request and applied it only to single-value select lists
* upgraded the Select2 libraries to version 3.4.6 ([issue #26](https://github.com/nbuytaert1/apex-select2/issues/26))
* fixed [issue #24](https://github.com/nbuytaert1/apex-select2/issues/24)

####v2.4.1 - 09/04/2014
* fixed [issue #28](https://github.com/nbuytaert1/apex-select2/issues/28)

####v2.4.2 - 03/09/2014
* upgraded the Select2 libraries to version 3.5.1 ([issue #29](https://github.com/nbuytaert1/apex-select2/issues/29))

####v2.4.3 - 07/11/2014
* upgraded the Select2 libraries to version 3.5.2

####v2.5 - 30/12/2014
* implemented lazy loading ([issue #30](https://github.com/nbuytaert1/apex-select2/issues/30))

####v2.6 - 11/01/2015
* improved lazy loading - no remote data process needed anymore
* added the lazy-appending feature ([issue #32](https://github.com/nbuytaert1/apex-select2/issues/32))
* added an application attribute to make the "Loading more results..." message adjustable

####v2.6.1 - 10/02/2015
* extended the matcher function with more search options: "Starts With & Ignore Case" and "Starts With & Case Sensitive"([issue #37](https://github.com/nbuytaert1/apex-select2/issues/37))

####v2.6.2 - 14/02/2015
* trigger change event in the apex.jQuery namespace when working with multiple jQuery versions ([issue #38](https://github.com/nbuytaert1/apex-select2/issues/38)) - pull request by Stijn Van Raes
* synchronized Select2 and APEX_PLUGIN_UTIL search logic

####v2.6.4 - 01/10/2015
* Universal Theme integration (select2-ut.css)
* added support for the $s() function in multi-select mode

####v3.0.0 - 31/05/2016
* upgraded the Select2 library files to version 4.0.3 ([issue #33](https://github.com/nbuytaert1/apex-select2/issues/33))