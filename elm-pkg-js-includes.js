// @NOTE this file will hopefully be auto-generated by elm-pkg-js in future!
// For now, its presense will mean Lamdera detects the extra JS and packages
// In future this will be more structured + restricted once the design is done

const katexJs = require('./elm-pkg-js/katex')
const vegaLiteJs = require('./elm-pkg-js/vegaLite')

exports.init = async function init(app) {
    // @WARNING: this only runs for Lamdera production deploys!
    // This file will not run in Local development, an equivalent to this is
    // automatically generated in Local Development for every file in elm-pkg-js/
    katexJs.init(app);
    vegaLiteJs.init(app);
}
