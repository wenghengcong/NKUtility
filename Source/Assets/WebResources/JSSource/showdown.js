/*! showdown v 1.9.1 - 02-11-2019 */
(function() {
    function e(e) {
        "use strict";
        var r = {
            omitExtraWLInCodeBlocks: {
                defaultValue: !1,
                describe: "Omit the default extra whiteline added to code blocks",
                type: "boolean"
            },
            noHeaderId: {
                defaultValue: !1,
                describe: "Turn on/off generated header id",
                type: "boolean"
            },
            prefixHeaderId: {
                defaultValue: !1,
                describe: "Add a prefix to the generated header ids. Passing a string will prefix that string to the header id. Setting to true will add a generic 'section-' prefix",
                type: "string"
            },
            rawPrefixHeaderId: {
                defaultValue: !1,
                describe: 'Setting this option to true will prevent showdown from modifying the prefix. This might result in malformed IDs (if, for instance, the " char is used in the prefix)',
                type: "boolean"
            },
            ghCompatibleHeaderId: {
                defaultValue: !1,
                describe: "Generate header ids compatible with github style (spaces are replaced with dashes, a bunch of non alphanumeric chars are removed)",
                type: "boolean"
            },
            rawHeaderId: {
                defaultValue: !1,
                describe: "Remove only spaces, ' and \" from generated header ids (including prefixes), replacing them with dashes (-). WARNING: This might result in malformed ids",
                type: "boolean"
            },
            headerLevelStart: {
                defaultValue: !1,
                describe: "The header blocks level start",
                type: "integer"
            },
            parseImgDimensions: {
                defaultValue: !1,
                describe: "Turn on/off image dimension parsing",
                type: "boolean"
            },
            simplifiedAutoLink: {
                defaultValue: !1,
                describe: "Turn on/off GFM autolink style",
                type: "boolean"
            },
            excludeTrailingPunctuationFromURLs: {
                defaultValue: !1,
                describe: "Excludes trailing punctuation from links generated with autoLinking",
                type: "boolean"
            },
            literalMidWordUnderscores: {
                defaultValue: !1,
                describe: "Parse midword underscores as literal underscores",
                type: "boolean"
            },
            literalMidWordAsterisks: {
                defaultValue: !1,
                describe: "Parse midword asterisks as literal asterisks",
                type: "boolean"
            },
            strikethrough: {
                defaultValue: !1,
                describe: "Turn on/off strikethrough support",
                type: "boolean"
            },
            tables: {
                defaultValue: !1,
                describe: "Turn on/off tables support",
                type: "boolean"
            },
            tablesHeaderId: {
                defaultValue: !1,
                describe: "Add an id to table headers",
                type: "boolean"
            },
            ghCodeBlocks: {
                defaultValue: !0,
                describe: "Turn on/off GFM fenced code blocks support",
                type: "boolean"
            },
            tasklists: {
                defaultValue: !1,
                describe: "Turn on/off GFM tasklist support",
                type: "boolean"
            },
            smoothLivePreview: {
                defaultValue: !1,
                describe: "Prevents weird effects in live previews due to incomplete input",
                type: "boolean"
            },
            smartIndentationFix: {
                defaultValue: !1,
                description: "Tries to smartly fix indentation in es6 strings",
                type: "boolean"
            },
            disableForced4SpacesIndentedSublists: {
                defaultValue: !1,
                description: "Disables the requirement of indenting nested sublists by 4 spaces",
                type: "boolean"
            },
            simpleLineBreaks: {
                defaultValue: !1,
                description: "Parses simple line breaks as <br> (GFM Style)",
                type: "boolean"
            },
            requireSpaceBeforeHeadingText: {
                defaultValue: !1,
                description: "Makes adding a space between `#` and the header text mandatory (GFM Style)",
                type: "boolean"
            },
            ghMentions: {
                defaultValue: !1,
                description: "Enables github @mentions",
                type: "boolean"
            },
            ghMentionsLink: {
                defaultValue: "https://github.com/{u}",
                description: "Changes the link generated by @mentions. Only applies if ghMentions option is enabled.",
                type: "string"
            },
            encodeEmails: {
                defaultValue: !0,
                description: "Encode e-mail addresses through the use of Character Entities, transforming ASCII e-mail addresses into its equivalent decimal entities",
                type: "boolean"
            },
            openLinksInNewWindow: {
                defaultValue: !1,
                description: "Open all links in new windows",
                type: "boolean"
            },
            backslashEscapesHTMLTags: {
                defaultValue: !1,
                description: "Support for HTML Tag escaping. ex: <div>foo</div>",
                type: "boolean"
            },
            emoji: {
                defaultValue: !1,
                description: "Enable emoji support. Ex: `this is a :smile: emoji`",
                type: "boolean"
            },
            underline: {
                defaultValue: !1,
                description: "Enable support for underline. Syntax is double or triple underscores: `__underline word__`. With this option enabled, underscores no longer parses into `<em>` and `<strong>`",
                type: "boolean"
            },
            completeHTMLDocument: {
                defaultValue: !1,
                description: "Outputs a complete html document, including `<html>`, `<head>` and `<body>` tags",
                type: "boolean"
            },
            metadata: {
                defaultValue: !1,
                description: "Enable support for document metadata (defined at the top of the document between `«««` and `»»»` or between `---` and `---`).",
                type: "boolean"
            },
            splitAdjacentBlockquotes: {
                defaultValue: !1,
                description: "Split adjacent blockquote blocks",
                type: "boolean"
            }
        };
        if (!1 === e) return JSON.parse(JSON.stringify(r));
        var t = {};
        for (var a in r) r.hasOwnProperty(a) && (t[a] = r[a].defaultValue);
        return t
    }
    function r(e, r) {
        "use strict";
        var t = r ? "Error in " + r + " extension->": "Error in unnamed extension",
        n = {
            valid: !0,
            error: ""
        };
        a.helper.isArray(e) || (e = [e]);
        for (var s = 0; s < e.length; ++s) {
            var o = t + " sub-extension " + s + ": ",
            i = e[s];
            if ("object" != typeof i) return n.valid = !1,
            n.error = o + "must be an object, but " + typeof i + " given",
            n;
            if (!a.helper.isString(i.type)) return n.valid = !1,
            n.error = o + 'property "type" must be a string, but ' + typeof i.type + " given",
            n;
            var l = i.type = i.type.toLowerCase();
            if ("language" === l && (l = i.type = "lang"), "html" === l && (l = i.type = "output"), "lang" !== l && "output" !== l && "listener" !== l) return n.valid = !1,
            n.error = o + "type " + l + ' is not recognized. Valid values: "lang/language", "output/html" or "listener"',
            n;
            if ("listener" === l) {
                if (a.helper.isUndefined(i.listeners)) return n.valid = !1,
                n.error = o + '. Extensions of type "listener" must have a property called "listeners"',
                n
            } else if (a.helper.isUndefined(i.filter) && a.helper.isUndefined(i.regex)) return n.valid = !1,
            n.error = o + l + ' extensions must define either a "regex" property or a "filter" method',
            n;
            if (i.listeners) {
                if ("object" != typeof i.listeners) return n.valid = !1,
                n.error = o + '"listeners" property must be an object but ' + typeof i.listeners + " given",
                n;
                for (var c in i.listeners) if (i.listeners.hasOwnProperty(c) && "function" != typeof i.listeners[c]) return n.valid = !1,
                n.error = o + '"listeners" property must be an hash of [event name]: [callback]. listeners.' + c + " must be a function but " + typeof i.listeners[c] + " given",
                n
            }
            if (i.filter) {
                if ("function" != typeof i.filter) return n.valid = !1,
                n.error = o + '"filter" must be a function, but ' + typeof i.filter + " given",
                n
            } else if (i.regex) {
                if (a.helper.isString(i.regex) && (i.regex = new RegExp(i.regex, "g")), !(i.regex instanceof RegExp)) return n.valid = !1,
                n.error = o + '"regex" property must either be a string or a RegExp object, but ' + typeof i.regex + " given",
                n;
                if (a.helper.isUndefined(i.replace)) return n.valid = !1,
                n.error = o + '"regex" extensions must implement a replace string or function',
                n
            }
        }
        return n
    }
    function t(e, r) {
        "use strict";
        return "¨E" + r.charCodeAt(0) + "E"
    }
    var a = {},
    n = {},
    s = {},
    o = e(!0),
    i = "vanilla",
    l = {
        github: {
            omitExtraWLInCodeBlocks: !0,
            simplifiedAutoLink: !0,
            excludeTrailingPunctuationFromURLs: !0,
            literalMidWordUnderscores: !0,
            strikethrough: !0,
            tables: !0,
            tablesHeaderId: !0,
            ghCodeBlocks: !0,
            tasklists: !0,
            disableForced4SpacesIndentedSublists: !0,
            simpleLineBreaks: !0,
            requireSpaceBeforeHeadingText: !0,
            ghCompatibleHeaderId: !0,
            ghMentions: !0,
            backslashEscapesHTMLTags: !0,
            emoji: !0,
            splitAdjacentBlockquotes: !0
        },
        original: {
            noHeaderId: !0,
            ghCodeBlocks: !1
        },
        ghost: {
            omitExtraWLInCodeBlocks: !0,
            parseImgDimensions: !0,
            simplifiedAutoLink: !0,
            excludeTrailingPunctuationFromURLs: !0,
            literalMidWordUnderscores: !0,
            strikethrough: !0,
            tables: !0,
            tablesHeaderId: !0,
            ghCodeBlocks: !0,
            tasklists: !0,
            smoothLivePreview: !0,
            simpleLineBreaks: !0,
            requireSpaceBeforeHeadingText: !0,
            ghMentions: !1,
            encodeEmails: !0
        },
        vanilla: e(!0),
        allOn: function() {
            "use strict";
            var r = e(!0),
            t = {};
            for (var a in r) r.hasOwnProperty(a) && (t[a] = !0);
            return t
        } ()
    };
    a.helper = {},
    a.extensions = {},
    a.setOption = function(e, r) {
        "use strict";
        return o[e] = r,
        this
    },
    a.getOption = function(e) {
        "use strict";
        return o[e]
    },
    a.getOptions = function() {
        "use strict";
        return o
    },
    a.resetOptions = function() {
        "use strict";
        o = e(!0)
    },
    a.setFlavor = function(e) {
        "use strict";
        if (!l.hasOwnProperty(e)) throw Error(e + " flavor was not found");
        a.resetOptions();
        var r = l[e];
        i = e;
        for (var t in r) r.hasOwnProperty(t) && (o[t] = r[t])
    },
    a.getFlavor = function() {
        "use strict";
        return i
    },
    a.getFlavorOptions = function(e) {
        "use strict";
        if (l.hasOwnProperty(e)) return l[e]
    },
    a.getDefaultOptions = function(r) {
        "use strict";
        return e(r)
    },
    a.subParser = function(e, r) {
        "use strict";
        if (a.helper.isString(e)) {
            if (void 0 === r) {
                if (n.hasOwnProperty(e)) return n[e];
                throw Error("SubParser named " + e + " not registered!")
            }
            n[e] = r
        }
    },
    a.extension = function(e, t) {
        "use strict";
        if (!a.helper.isString(e)) throw Error("Extension 'name' must be a string");
        if (e = a.helper.stdExtName(e), a.helper.isUndefined(t)) {
            if (!s.hasOwnProperty(e)) throw Error("Extension named " + e + " is not registered!");
            return s[e]
        }
        "function" == typeof t && (t = t()),
        a.helper.isArray(t) || (t = [t]);
        var n = r(t, e);
        if (!n.valid) throw Error(n.error);
        s[e] = t
    },
    a.getAllExtensions = function() {
        "use strict";
        return s
    },
    a.removeExtension = function(e) {
        "use strict";
        delete s[e]
    },
    a.resetExtensions = function() {
        "use strict";
        s = {}
    },
    a.validateExtension = function(e) {
        "use strict";
        var t = r(e, null);
        return !! t.valid || (console.warn(t.error), !1)
    },
    a.hasOwnProperty("helper") || (a.helper = {}),
    a.helper.isString = function(e) {
        "use strict";
        return "string" == typeof e || e instanceof String
    },
    a.helper.isFunction = function(e) {
        "use strict";
        return e && "[object Function]" === {}.toString.call(e)
    },
    a.helper.isArray = function(e) {
        "use strict";
        return Array.isArray(e)
    },
    a.helper.isUndefined = function(e) {
        "use strict";
        return void 0 === e
    },
    a.helper.forEach = function(e, r) {
        "use strict";
        if (a.helper.isUndefined(e)) throw new Error("obj param is required");
        if (a.helper.isUndefined(r)) throw new Error("callback param is required");
        if (!a.helper.isFunction(r)) throw new Error("callback param must be a function/closure");
        if ("function" == typeof e.forEach) e.forEach(r);
        else if (a.helper.isArray(e)) for (var t = 0; t < e.length; t++) r(e[t], t, e);
        else {
            if ("object" != typeof e) throw new Error("obj does not seem to be an array or an iterable object");
            for (var n in e) e.hasOwnProperty(n) && r(e[n], n, e)
        }
    },
    a.helper.stdExtName = function(e) {
        "use strict";
        return e.replace(/[_?*+\/\\.^-]/g, "").replace(/\s/g, "").toLowerCase()
    },
    a.helper.escapeCharactersCallback = t,
    a.helper.escapeCharacters = function(e, r, a) {
        "use strict";
        var n = "([" + r.replace(/([\[\]\\])/g, "\\$1") + "])";
        a && (n = "\\\\" + n);
        var s = new RegExp(n, "g");
        return e = e.replace(s, t)
    },
    a.helper.unescapeHTMLEntities = function(e) {
        "use strict";
        return e.replace(/&quot;/g, '"').replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&amp;/g, "&")
    };
    var c = function(e, r, t, a) {
        "use strict";
        var n, s, o, i, l, c = a || "",
        u = c.indexOf("g") > -1,
        d = new RegExp(r + "|" + t, "g" + c.replace(/g/g, "")),
        p = new RegExp(r, c.replace(/g/g, "")),
        h = [];
        do {
            for (n = 0; o = d.exec(e);) if (p.test(o[0])) n++||(i = (s = d.lastIndex) - o[0].length);
            else if (n && !--n) {
                l = o.index + o[0].length;
                var _ = {
                    left: {
                        start: i,
                        end: s
                    },
                    match: {
                        start: s,
                        end: o.index
                    },
                    right: {
                        start: o.index,
                        end: l
                    },
                    wholeMatch: {
                        start: i,
                        end: l
                    }
                };
                if (h.push(_), !u) return h
            }
        } while ( n && ( d . lastIndex = s ));
        return h
    };
    a.helper.matchRecursiveRegExp = function(e, r, t, a) {
        "use strict";
        for (var n = c(e, r, t, a), s = [], o = 0; o < n.length; ++o) s.push([e.slice(n[o].wholeMatch.start, n[o].wholeMatch.end), e.slice(n[o].match.start, n[o].match.end), e.slice(n[o].left.start, n[o].left.end), e.slice(n[o].right.start, n[o].right.end)]);
        return s
    },
    a.helper.replaceRecursiveRegExp = function(e, r, t, n, s) {
        "use strict";
        if (!a.helper.isFunction(r)) {
            var o = r;
            r = function() {
                return o
            }
        }
        var i = c(e, t, n, s),
        l = e,
        u = i.length;
        if (u > 0) {
            var d = [];
            0 !== i[0].wholeMatch.start && d.push(e.slice(0, i[0].wholeMatch.start));
            for (var p = 0; p < u; ++p) d.push(r(e.slice(i[p].wholeMatch.start, i[p].wholeMatch.end), e.slice(i[p].match.start, i[p].match.end), e.slice(i[p].left.start, i[p].left.end), e.slice(i[p].right.start, i[p].right.end))),
            p < u - 1 && d.push(e.slice(i[p].wholeMatch.end, i[p + 1].wholeMatch.start));
            i[u - 1].wholeMatch.end < e.length && d.push(e.slice(i[u - 1].wholeMatch.end)),
            l = d.join("")
        }
        return l
    },
    a.helper.regexIndexOf = function(e, r, t) {
        "use strict";
        if (!a.helper.isString(e)) throw "InvalidArgumentError: first parameter of showdown.helper.regexIndexOf function must be a string";
        if (r instanceof RegExp == !1) throw "InvalidArgumentError: second parameter of showdown.helper.regexIndexOf function must be an instance of RegExp";
        var n = e.substring(t || 0).search(r);
        return n >= 0 ? n + (t || 0) : n
    },
    a.helper.splitAtIndex = function(e, r) {
        "use strict";
        if (!a.helper.isString(e)) throw "InvalidArgumentError: first parameter of showdown.helper.regexIndexOf function must be a string";
        return [e.substring(0, r), e.substring(r)]
    },
    a.helper.encodeEmailAddress = function(e) {
        "use strict";
        var r = [function(e) {
            return "&#" + e.charCodeAt(0) + ";"
        },
        function(e) {
            return "&#x" + e.charCodeAt(0).toString(16) + ";"
        },
        function(e) {
            return e
        }];
        return e = e.replace(/./g,
        function(e) {
            if ("@" === e) e = r[Math.floor(2 * Math.random())](e);
            else {
                var t = Math.random();
                e = t > .9 ? r[2](e) : t > .45 ? r[1](e) : r[0](e)
            }
            return e
        })
    },
    a.helper.padEnd = function(e, r, t) {
        "use strict";
        return r >>= 0,
        t = String(t || " "),
        e.length > r ? String(e) : ((r -= e.length) > t.length && (t += t.repeat(r / t.length)), String(e) + t.slice(0, r))
    },
    "undefined" == typeof console && (console = {
        warn: function(e) {
            "use strict";
            alert(e)
        },
        log: function(e) {
            "use strict";
            alert(e)
        },
        error: function(e) {
            "use strict";
            throw e
        }
    }),
    a.helper.regexes = {
        asteriskDashAndColon: /([*_:~])/g
    },
    a.helper.emojis = {
        "+1": "👍",
        "-1": "👎",
        100 : "💯",
        1234 : "🔢",
        "1st_place_medal": "🥇",
        "2nd_place_medal": "🥈",
        "3rd_place_medal": "🥉",
        "8ball": "🎱",
        a: "🅰️",
        ab: "🆎",
        abc: "🔤",
        abcd: "🔡",
        accept: "🉑",
        aerial_tramway: "🚡",
        airplane: "✈️",
        alarm_clock: "⏰",
        alembic: "⚗️",
        alien: "👽",
        ambulance: "🚑",
        amphora: "🏺",
        anchor: "⚓️",
        angel: "👼",
        anger: "💢",
        angry: "😠",
        anguished: "😧",
        ant: "🐜",
        apple: "🍎",
        aquarius: "♒️",
        aries: "♈️",
        arrow_backward: "◀️",
        arrow_double_down: "⏬",
        arrow_double_up: "⏫",
        arrow_down: "⬇️",
        arrow_down_small: "🔽",
        arrow_forward: "▶️",
        arrow_heading_down: "⤵️",
        arrow_heading_up: "⤴️",
        arrow_left: "⬅️",
        arrow_lower_left: "↙️",
        arrow_lower_right: "↘️",
        arrow_right: "➡️",
        arrow_right_hook: "↪️",
        arrow_up: "⬆️",
        arrow_up_down: "↕️",
        arrow_up_small: "🔼",
        arrow_upper_left: "↖️",
        arrow_upper_right: "↗️",
        arrows_clockwise: "🔃",
        arrows_counterclockwise: "🔄",
        art: "🎨",
        articulated_lorry: "🚛",
        artificial_satellite: "🛰",
        astonished: "😲",
        athletic_shoe: "👟",
        atm: "🏧",
        atom_symbol: "⚛️",
        avocado: "🥑",
        b: "🅱️",
        baby: "👶",
        baby_bottle: "🍼",
        baby_chick: "🐤",
        baby_symbol: "🚼",
        back: "🔙",
        bacon: "🥓",
        badminton: "🏸",
        baggage_claim: "🛄",
        baguette_bread: "🥖",
        balance_scale: "⚖️",
        balloon: "🎈",
        ballot_box: "🗳",
        ballot_box_with_check: "☑️",
        bamboo: "🎍",
        banana: "🍌",
        bangbang: "‼️",
        bank: "🏦",
        bar_chart: "📊",
        barber: "💈",
        baseball: "⚾️",
        basketball: "🏀",
        basketball_man: "⛹️",
        basketball_woman: "⛹️&zwj;♀️",
        bat: "🦇",
        bath: "🛀",
        bathtub: "🛁",
        battery: "🔋",
        beach_umbrella: "🏖",
        bear: "🐻",
        bed: "🛏",
        bee: "🐝",
        beer: "🍺",
        beers: "🍻",
        beetle: "🐞",
        beginner: "🔰",
        bell: "🔔",
        bellhop_bell: "🛎",
        bento: "🍱",
        biking_man: "🚴",
        bike: "🚲",
        biking_woman: "🚴&zwj;♀️",
        bikini: "👙",
        biohazard: "☣️",
        bird: "🐦",
        birthday: "🎂",
        black_circle: "⚫️",
        black_flag: "🏴",
        black_heart: "🖤",
        black_joker: "🃏",
        black_large_square: "⬛️",
        black_medium_small_square: "◾️",
        black_medium_square: "◼️",
        black_nib: "✒️",
        black_small_square: "▪️",
        black_square_button: "🔲",
        blonde_man: "👱",
        blonde_woman: "👱&zwj;♀️",
        blossom: "🌼",
        blowfish: "🐡",
        blue_book: "📘",
        blue_car: "🚙",
        blue_heart: "💙",
        blush: "😊",
        boar: "🐗",
        boat: "⛵️",
        bomb: "💣",
        book: "📖",
        bookmark: "🔖",
        bookmark_tabs: "📑",
        books: "📚",
        boom: "💥",
        boot: "👢",
        bouquet: "💐",
        bowing_man: "🙇",
        bow_and_arrow: "🏹",
        bowing_woman: "🙇&zwj;♀️",
        bowling: "🎳",
        boxing_glove: "🥊",
        boy: "👦",
        bread: "🍞",
        bride_with_veil: "👰",
        bridge_at_night: "🌉",
        briefcase: "💼",
        broken_heart: "💔",
        bug: "🐛",
        building_construction: "🏗",
        bulb: "💡",
        bullettrain_front: "🚅",
        bullettrain_side: "🚄",
        burrito: "🌯",
        bus: "🚌",
        business_suit_levitating: "🕴",
        busstop: "🚏",
        bust_in_silhouette: "👤",
        busts_in_silhouette: "👥",
        butterfly: "🦋",
        cactus: "🌵",
        cake: "🍰",
        calendar: "📆",
        call_me_hand: "🤙",
        calling: "📲",
        camel: "🐫",
        camera: "📷",
        camera_flash: "📸",
        camping: "🏕",
        cancer: "♋️",
        candle: "🕯",
        candy: "🍬",
        canoe: "🛶",
        capital_abcd: "🔠",
        capricorn: "♑️",
        car: "🚗",
        card_file_box: "🗃",
        card_index: "📇",
        card_index_dividers: "🗂",
        carousel_horse: "🎠",
        carrot: "🥕",
        cat: "🐱",
        cat2: "🐈",
        cd: "💿",
        chains: "⛓",
        champagne: "🍾",
        chart: "💹",
        chart_with_downwards_trend: "📉",
        chart_with_upwards_trend: "📈",
        checkered_flag: "🏁",
        cheese: "🧀",
        cherries: "🍒",
        cherry_blossom: "🌸",
        chestnut: "🌰",
        chicken: "🐔",
        children_crossing: "🚸",
        chipmunk: "🐿",
        chocolate_bar: "🍫",
        christmas_tree: "🎄",
        church: "⛪️",
        cinema: "🎦",
        circus_tent: "🎪",
        city_sunrise: "🌇",
        city_sunset: "🌆",
        cityscape: "🏙",
        cl: "🆑",
        clamp: "🗜",
        clap: "👏",
        clapper: "🎬",
        classical_building: "🏛",
        clinking_glasses: "🥂",
        clipboard: "📋",
        clock1: "🕐",
        clock10: "🕙",
        clock1030: "🕥",
        clock11: "🕚",
        clock1130: "🕦",
        clock12: "🕛",
        clock1230: "🕧",
        clock130: "🕜",
        clock2: "🕑",
        clock230: "🕝",
        clock3: "🕒",
        clock330: "🕞",
        clock4: "🕓",
        clock430: "🕟",
        clock5: "🕔",
        clock530: "🕠",
        clock6: "🕕",
        clock630: "🕡",
        clock7: "🕖",
        clock730: "🕢",
        clock8: "🕗",
        clock830: "🕣",
        clock9: "🕘",
        clock930: "🕤",
        closed_book: "📕",
        closed_lock_with_key: "🔐",
        closed_umbrella: "🌂",
        cloud: "☁️",
        cloud_with_lightning: "🌩",
        cloud_with_lightning_and_rain: "⛈",
        cloud_with_rain: "🌧",
        cloud_with_snow: "🌨",
        clown_face: "🤡",
        clubs: "♣️",
        cocktail: "🍸",
        coffee: "☕️",
        coffin: "⚰️",
        cold_sweat: "😰",
        comet: "☄️",
        computer: "💻",
        computer_mouse: "🖱",
        confetti_ball: "🎊",
        confounded: "😖",
        confused: "😕",
        congratulations: "㊗️",
        construction: "🚧",
        construction_worker_man: "👷",
        construction_worker_woman: "👷&zwj;♀️",
        control_knobs: "🎛",
        convenience_store: "🏪",
        cookie: "🍪",
        cool: "🆒",
        policeman: "👮",
        copyright: "©️",
        corn: "🌽",
        couch_and_lamp: "🛋",
        couple: "👫",
        couple_with_heart_woman_man: "💑",
        couple_with_heart_man_man: "👨&zwj;❤️&zwj;👨",
        couple_with_heart_woman_woman: "👩&zwj;❤️&zwj;👩",
        couplekiss_man_man: "👨&zwj;❤️&zwj;💋&zwj;👨",
        couplekiss_man_woman: "💏",
        couplekiss_woman_woman: "👩&zwj;❤️&zwj;💋&zwj;👩",
        cow: "🐮",
        cow2: "🐄",
        cowboy_hat_face: "🤠",
        crab: "🦀",
        crayon: "🖍",
        credit_card: "💳",
        crescent_moon: "🌙",
        cricket: "🏏",
        crocodile: "🐊",
        croissant: "🥐",
        crossed_fingers: "🤞",
        crossed_flags: "🎌",
        crossed_swords: "⚔️",
        crown: "👑",
        cry: "😢",
        crying_cat_face: "😿",
        crystal_ball: "🔮",
        cucumber: "🥒",
        cupid: "💘",
        curly_loop: "➰",
        currency_exchange: "💱",
        curry: "🍛",
        custard: "🍮",
        customs: "🛃",
        cyclone: "🌀",
        dagger: "🗡",
        dancer: "💃",
        dancing_women: "👯",
        dancing_men: "👯&zwj;♂️",
        dango: "🍡",
        dark_sunglasses: "🕶",
        dart: "🎯",
        dash: "💨",
        date: "📅",
        deciduous_tree: "🌳",
        deer: "🦌",
        department_store: "🏬",
        derelict_house: "🏚",
        desert: "🏜",
        desert_island: "🏝",
        desktop_computer: "🖥",
        male_detective: "🕵️",
        diamond_shape_with_a_dot_inside: "💠",
        diamonds: "♦️",
        disappointed: "😞",
        disappointed_relieved: "😥",
        dizzy: "💫",
        dizzy_face: "😵",
        do_not_litter: "🚯",
        dog: "🐶",
        dog2: "🐕",
        dollar: "💵",
        dolls: "🎎",
        dolphin: "🐬",
        door: "🚪",
        doughnut: "🍩",
        dove: "🕊",
        dragon: "🐉",
        dragon_face: "🐲",
        dress: "👗",
        dromedary_camel: "🐪",
        drooling_face: "🤤",
        droplet: "💧",
        drum: "🥁",
        duck: "🦆",
        dvd: "📀",
        "e-mail": "📧",
        eagle: "🦅",
        ear: "👂",
        ear_of_rice: "🌾",
        earth_africa: "🌍",
        earth_americas: "🌎",
        earth_asia: "🌏",
        egg: "🥚",
        eggplant: "🍆",
        eight_pointed_black_star: "✴️",
        eight_spoked_asterisk: "✳️",
        electric_plug: "🔌",
        elephant: "🐘",
        email: "✉️",
        end: "🔚",
        envelope_with_arrow: "📩",
        euro: "💶",
        european_castle: "🏰",
        european_post_office: "🏤",
        evergreen_tree: "🌲",
        exclamation: "❗️",
        expressionless: "😑",
        eye: "👁",
        eye_speech_bubble: "👁&zwj;🗨",
        eyeglasses: "👓",
        eyes: "👀",
        face_with_head_bandage: "🤕",
        face_with_thermometer: "🤒",
        fist_oncoming: "👊",
        factory: "🏭",
        fallen_leaf: "🍂",
        family_man_woman_boy: "👪",
        family_man_boy: "👨&zwj;👦",
        family_man_boy_boy: "👨&zwj;👦&zwj;👦",
        family_man_girl: "👨&zwj;👧",
        family_man_girl_boy: "👨&zwj;👧&zwj;👦",
        family_man_girl_girl: "👨&zwj;👧&zwj;👧",
        family_man_man_boy: "👨&zwj;👨&zwj;👦",
        family_man_man_boy_boy: "👨&zwj;👨&zwj;👦&zwj;👦",
        family_man_man_girl: "👨&zwj;👨&zwj;👧",
        family_man_man_girl_boy: "👨&zwj;👨&zwj;👧&zwj;👦",
        family_man_man_girl_girl: "👨&zwj;👨&zwj;👧&zwj;👧",
        family_man_woman_boy_boy: "👨&zwj;👩&zwj;👦&zwj;👦",
        family_man_woman_girl: "👨&zwj;👩&zwj;👧",
        family_man_woman_girl_boy: "👨&zwj;👩&zwj;👧&zwj;👦",
        family_man_woman_girl_girl: "👨&zwj;👩&zwj;👧&zwj;👧",
        family_woman_boy: "👩&zwj;👦",
        family_woman_boy_boy: "👩&zwj;👦&zwj;👦",
        family_woman_girl: "👩&zwj;👧",
        family_woman_girl_boy: "👩&zwj;👧&zwj;👦",
        family_woman_girl_girl: "👩&zwj;👧&zwj;👧",
        family_woman_woman_boy: "👩&zwj;👩&zwj;👦",
        family_woman_woman_boy_boy: "👩&zwj;👩&zwj;👦&zwj;👦",
        family_woman_woman_girl: "👩&zwj;👩&zwj;👧",
        family_woman_woman_girl_boy: "👩&zwj;👩&zwj;👧&zwj;👦",
        family_woman_woman_girl_girl: "👩&zwj;👩&zwj;👧&zwj;👧",
        fast_forward: "⏩",
        fax: "📠",
        fearful: "😨",
        feet: "🐾",
        female_detective: "🕵️&zwj;♀️",
        ferris_wheel: "🎡",
        ferry: "⛴",
        field_hockey: "🏑",
        file_cabinet: "🗄",
        file_folder: "📁",
        film_projector: "📽",
        film_strip: "🎞",
        fire: "🔥",
        fire_engine: "🚒",
        fireworks: "🎆",
        first_quarter_moon: "🌓",
        first_quarter_moon_with_face: "🌛",
        fish: "🐟",
        fish_cake: "🍥",
        fishing_pole_and_fish: "🎣",
        fist_raised: "✊",
        fist_left: "🤛",
        fist_right: "🤜",
        flags: "🎏",
        flashlight: "🔦",
        fleur_de_lis: "⚜️",
        flight_arrival: "🛬",
        flight_departure: "🛫",
        floppy_disk: "💾",
        flower_playing_cards: "🎴",
        flushed: "😳",
        fog: "🌫",
        foggy: "🌁",
        football: "🏈",
        footprints: "👣",
        fork_and_knife: "🍴",
        fountain: "⛲️",
        fountain_pen: "🖋",
        four_leaf_clover: "🍀",
        fox_face: "🦊",
        framed_picture: "🖼",
        free: "🆓",
        fried_egg: "🍳",
        fried_shrimp: "🍤",
        fries: "🍟",
        frog: "🐸",
        frowning: "😦",
        frowning_face: "☹️",
        frowning_man: "🙍&zwj;♂️",
        frowning_woman: "🙍",
        middle_finger: "🖕",
        fuelpump: "⛽️",
        full_moon: "🌕",
        full_moon_with_face: "🌝",
        funeral_urn: "⚱️",
        game_die: "🎲",
        gear: "⚙️",
        gem: "💎",
        gemini: "♊️",
        ghost: "👻",
        gift: "🎁",
        gift_heart: "💝",
        girl: "👧",
        globe_with_meridians: "🌐",
        goal_net: "🥅",
        goat: "🐐",
        golf: "⛳️",
        golfing_man: "🏌️",
        golfing_woman: "🏌️&zwj;♀️",
        gorilla: "🦍",
        grapes: "🍇",
        green_apple: "🍏",
        green_book: "📗",
        green_heart: "💚",
        green_salad: "🥗",
        grey_exclamation: "❕",
        grey_question: "❔",
        grimacing: "😬",
        grin: "😁",
        grinning: "😀",
        guardsman: "💂",
        guardswoman: "💂&zwj;♀️",
        guitar: "🎸",
        gun: "🔫",
        haircut_woman: "💇",
        haircut_man: "💇&zwj;♂️",
        hamburger: "🍔",
        hammer: "🔨",
        hammer_and_pick: "⚒",
        hammer_and_wrench: "🛠",
        hamster: "🐹",
        hand: "✋",
        handbag: "👜",
        handshake: "🤝",
        hankey: "💩",
        hatched_chick: "🐥",
        hatching_chick: "🐣",
        headphones: "🎧",
        hear_no_evil: "🙉",
        heart: "❤️",
        heart_decoration: "💟",
        heart_eyes: "😍",
        heart_eyes_cat: "😻",
        heartbeat: "💓",
        heartpulse: "💗",
        hearts: "♥️",
        heavy_check_mark: "✔️",
        heavy_division_sign: "➗",
        heavy_dollar_sign: "💲",
        heavy_heart_exclamation: "❣️",
        heavy_minus_sign: "➖",
        heavy_multiplication_x: "✖️",
        heavy_plus_sign: "➕",
        helicopter: "🚁",
        herb: "🌿",
        hibiscus: "🌺",
        high_brightness: "🔆",
        high_heel: "👠",
        hocho: "🔪",
        hole: "🕳",
        honey_pot: "🍯",
        horse: "🐴",
        horse_racing: "🏇",
        hospital: "🏥",
        hot_pepper: "🌶",
        hotdog: "🌭",
        hotel: "🏨",
        hotsprings: "♨️",
        hourglass: "⌛️",
        hourglass_flowing_sand: "⏳",
        house: "🏠",
        house_with_garden: "🏡",
        houses: "🏘",
        hugs: "🤗",
        hushed: "😯",
        ice_cream: "🍨",
        ice_hockey: "🏒",
        ice_skate: "⛸",
        icecream: "🍦",
        id: "🆔",
        ideograph_advantage: "🉐",
        imp: "👿",
        inbox_tray: "📥",
        incoming_envelope: "📨",
        tipping_hand_woman: "💁",
        information_source: "ℹ️",
        innocent: "😇",
        interrobang: "⁉️",
        iphone: "📱",
        izakaya_lantern: "🏮",
        jack_o_lantern: "🎃",
        japan: "🗾",
        japanese_castle: "🏯",
        japanese_goblin: "👺",
        japanese_ogre: "👹",
        jeans: "👖",
        joy: "😂",
        joy_cat: "😹",
        joystick: "🕹",
        kaaba: "🕋",
        key: "🔑",
        keyboard: "⌨️",
        keycap_ten: "🔟",
        kick_scooter: "🛴",
        kimono: "👘",
        kiss: "💋",
        kissing: "😗",
        kissing_cat: "😽",
        kissing_closed_eyes: "😚",
        kissing_heart: "😘",
        kissing_smiling_eyes: "😙",
        kiwi_fruit: "🥝",
        koala: "🐨",
        koko: "🈁",
        label: "🏷",
        large_blue_circle: "🔵",
        large_blue_diamond: "🔷",
        large_orange_diamond: "🔶",
        last_quarter_moon: "🌗",
        last_quarter_moon_with_face: "🌜",
        latin_cross: "✝️",
        laughing: "😆",
        leaves: "🍃",
        ledger: "📒",
        left_luggage: "🛅",
        left_right_arrow: "↔️",
        leftwards_arrow_with_hook: "↩️",
        lemon: "🍋",
        leo: "♌️",
        leopard: "🐆",
        level_slider: "🎚",
        libra: "♎️",
        light_rail: "🚈",
        link: "🔗",
        lion: "🦁",
        lips: "👄",
        lipstick: "💄",
        lizard: "🦎",
        lock: "🔒",
        lock_with_ink_pen: "🔏",
        lollipop: "🍭",
        loop: "➿",
        loud_sound: "🔊",
        loudspeaker: "📢",
        love_hotel: "🏩",
        love_letter: "💌",
        low_brightness: "🔅",
        lying_face: "🤥",
        m: "Ⓜ️",
        mag: "🔍",
        mag_right: "🔎",
        mahjong: "🀄️",
        mailbox: "📫",
        mailbox_closed: "📪",
        mailbox_with_mail: "📬",
        mailbox_with_no_mail: "📭",
        man: "👨",
        man_artist: "👨&zwj;🎨",
        man_astronaut: "👨&zwj;🚀",
        man_cartwheeling: "🤸&zwj;♂️",
        man_cook: "👨&zwj;🍳",
        man_dancing: "🕺",
        man_facepalming: "🤦&zwj;♂️",
        man_factory_worker: "👨&zwj;🏭",
        man_farmer: "👨&zwj;🌾",
        man_firefighter: "👨&zwj;🚒",
        man_health_worker: "👨&zwj;⚕️",
        man_in_tuxedo: "🤵",
        man_judge: "👨&zwj;⚖️",
        man_juggling: "🤹&zwj;♂️",
        man_mechanic: "👨&zwj;🔧",
        man_office_worker: "👨&zwj;💼",
        man_pilot: "👨&zwj;✈️",
        man_playing_handball: "🤾&zwj;♂️",
        man_playing_water_polo: "🤽&zwj;♂️",
        man_scientist: "👨&zwj;🔬",
        man_shrugging: "🤷&zwj;♂️",
        man_singer: "👨&zwj;🎤",
        man_student: "👨&zwj;🎓",
        man_teacher: "👨&zwj;🏫",
        man_technologist: "👨&zwj;💻",
        man_with_gua_pi_mao: "👲",
        man_with_turban: "👳",
        tangerine: "🍊",
        mans_shoe: "👞",
        mantelpiece_clock: "🕰",
        maple_leaf: "🍁",
        martial_arts_uniform: "🥋",
        mask: "😷",
        massage_woman: "💆",
        massage_man: "💆&zwj;♂️",
        meat_on_bone: "🍖",
        medal_military: "🎖",
        medal_sports: "🏅",
        mega: "📣",
        melon: "🍈",
        memo: "📝",
        men_wrestling: "🤼&zwj;♂️",
        menorah: "🕎",
        mens: "🚹",
        metal: "🤘",
        metro: "🚇",
        microphone: "🎤",
        microscope: "🔬",
        milk_glass: "🥛",
        milky_way: "🌌",
        minibus: "🚐",
        minidisc: "💽",
        mobile_phone_off: "📴",
        money_mouth_face: "🤑",
        money_with_wings: "💸",
        moneybag: "💰",
        monkey: "🐒",
        monkey_face: "🐵",
        monorail: "🚝",
        moon: "🌔",
        mortar_board: "🎓",
        mosque: "🕌",
        motor_boat: "🛥",
        motor_scooter: "🛵",
        motorcycle: "🏍",
        motorway: "🛣",
        mount_fuji: "🗻",
        mountain: "⛰",
        mountain_biking_man: "🚵",
        mountain_biking_woman: "🚵&zwj;♀️",
        mountain_cableway: "🚠",
        mountain_railway: "🚞",
        mountain_snow: "🏔",
        mouse: "🐭",
        mouse2: "🐁",
        movie_camera: "🎥",
        moyai: "🗿",
        mrs_claus: "🤶",
        muscle: "💪",
        mushroom: "🍄",
        musical_keyboard: "🎹",
        musical_note: "🎵",
        musical_score: "🎼",
        mute: "🔇",
        nail_care: "💅",
        name_badge: "📛",
        national_park: "🏞",
        nauseated_face: "🤢",
        necktie: "👔",
        negative_squared_cross_mark: "❎",
        nerd_face: "🤓",
        neutral_face: "😐",
        new: "🆕",
        new_moon: "🌑",
        new_moon_with_face: "🌚",
        newspaper: "📰",
        newspaper_roll: "🗞",
        next_track_button: "⏭",
        ng: "🆖",
        no_good_man: "🙅&zwj;♂️",
        no_good_woman: "🙅",
        night_with_stars: "🌃",
        no_bell: "🔕",
        no_bicycles: "🚳",
        no_entry: "⛔️",
        no_entry_sign: "🚫",
        no_mobile_phones: "📵",
        no_mouth: "😶",
        no_pedestrians: "🚷",
        no_smoking: "🚭",
        "non-potable_water": "🚱",
        nose: "👃",
        notebook: "📓",
        notebook_with_decorative_cover: "📔",
        notes: "🎶",
        nut_and_bolt: "🔩",
        o: "⭕️",
        o2: "🅾️",
        ocean: "🌊",
        octopus: "🐙",
        oden: "🍢",
        office: "🏢",
        oil_drum: "🛢",
        ok: "🆗",
        ok_hand: "👌",
        ok_man: "🙆&zwj;♂️",
        ok_woman: "🙆",
        old_key: "🗝",
        older_man: "👴",
        older_woman: "👵",
        om: "🕉",
        on: "🔛",
        oncoming_automobile: "🚘",
        oncoming_bus: "🚍",
        oncoming_police_car: "🚔",
        oncoming_taxi: "🚖",
        open_file_folder: "📂",
        open_hands: "👐",
        open_mouth: "😮",
        open_umbrella: "☂️",
        ophiuchus: "⛎",
        orange_book: "📙",
        orthodox_cross: "☦️",
        outbox_tray: "📤",
        owl: "🦉",
        ox: "🐂",
        package: "📦",
        page_facing_up: "📄",
        page_with_curl: "📃",
        pager: "📟",
        paintbrush: "🖌",
        palm_tree: "🌴",
        pancakes: "🥞",
        panda_face: "🐼",
        paperclip: "📎",
        paperclips: "🖇",
        parasol_on_ground: "⛱",
        parking: "🅿️",
        part_alternation_mark: "〽️",
        partly_sunny: "⛅️",
        passenger_ship: "🛳",
        passport_control: "🛂",
        pause_button: "⏸",
        peace_symbol: "☮️",
        peach: "🍑",
        peanuts: "🥜",
        pear: "🍐",
        pen: "🖊",
        pencil2: "✏️",
        penguin: "🐧",
        pensive: "😔",
        performing_arts: "🎭",
        persevere: "😣",
        person_fencing: "🤺",
        pouting_woman: "🙎",
        phone: "☎️",
        pick: "⛏",
        pig: "🐷",
        pig2: "🐖",
        pig_nose: "🐽",
        pill: "💊",
        pineapple: "🍍",
        ping_pong: "🏓",
        pisces: "♓️",
        pizza: "🍕",
        place_of_worship: "🛐",
        plate_with_cutlery: "🍽",
        play_or_pause_button: "⏯",
        point_down: "👇",
        point_left: "👈",
        point_right: "👉",
        point_up: "☝️",
        point_up_2: "👆",
        police_car: "🚓",
        policewoman: "👮&zwj;♀️",
        poodle: "🐩",
        popcorn: "🍿",
        post_office: "🏣",
        postal_horn: "📯",
        postbox: "📮",
        potable_water: "🚰",
        potato: "🥔",
        pouch: "👝",
        poultry_leg: "🍗",
        pound: "💷",
        rage: "😡",
        pouting_cat: "😾",
        pouting_man: "🙎&zwj;♂️",
        pray: "🙏",
        prayer_beads: "📿",
        pregnant_woman: "🤰",
        previous_track_button: "⏮",
        prince: "🤴",
        princess: "👸",
        printer: "🖨",
        purple_heart: "💜",
        purse: "👛",
        pushpin: "📌",
        put_litter_in_its_place: "🚮",
        question: "❓",
        rabbit: "🐰",
        rabbit2: "🐇",
        racehorse: "🐎",
        racing_car: "🏎",
        radio: "📻",
        radio_button: "🔘",
        radioactive: "☢️",
        railway_car: "🚃",
        railway_track: "🛤",
        rainbow: "🌈",
        rainbow_flag: "🏳️&zwj;🌈",
        raised_back_of_hand: "🤚",
        raised_hand_with_fingers_splayed: "🖐",
        raised_hands: "🙌",
        raising_hand_woman: "🙋",
        raising_hand_man: "🙋&zwj;♂️",
        ram: "🐏",
        ramen: "🍜",
        rat: "🐀",
        record_button: "⏺",
        recycle: "♻️",
        red_circle: "🔴",
        registered: "®️",
        relaxed: "☺️",
        relieved: "😌",
        reminder_ribbon: "🎗",
        repeat: "🔁",
        repeat_one: "🔂",
        rescue_worker_helmet: "⛑",
        restroom: "🚻",
        revolving_hearts: "💞",
        rewind: "⏪",
        rhinoceros: "🦏",
        ribbon: "🎀",
        rice: "🍚",
        rice_ball: "🍙",
        rice_cracker: "🍘",
        rice_scene: "🎑",
        right_anger_bubble: "🗯",
        ring: "💍",
        robot: "🤖",
        rocket: "🚀",
        rofl: "🤣",
        roll_eyes: "🙄",
        roller_coaster: "🎢",
        rooster: "🐓",
        rose: "🌹",
        rosette: "🏵",
        rotating_light: "🚨",
        round_pushpin: "📍",
        rowing_man: "🚣",
        rowing_woman: "🚣&zwj;♀️",
        rugby_football: "🏉",
        running_man: "🏃",
        running_shirt_with_sash: "🎽",
        running_woman: "🏃&zwj;♀️",
        sa: "🈂️",
        sagittarius: "♐️",
        sake: "🍶",
        sandal: "👡",
        santa: "🎅",
        satellite: "📡",
        saxophone: "🎷",
        school: "🏫",
        school_satchel: "🎒",
        scissors: "✂️",
        scorpion: "🦂",
        scorpius: "♏️",
        scream: "😱",
        scream_cat: "🙀",
        scroll: "📜",
        seat: "💺",
        secret: "㊙️",
        see_no_evil: "🙈",
        seedling: "🌱",
        selfie: "🤳",
        shallow_pan_of_food: "🥘",
        shamrock: "☘️",
        shark: "🦈",
        shaved_ice: "🍧",
        sheep: "🐑",
        shell: "🐚",
        shield: "🛡",
        shinto_shrine: "⛩",
        ship: "🚢",
        shirt: "👕",
        shopping: "🛍",
        shopping_cart: "🛒",
        shower: "🚿",
        shrimp: "🦐",
        signal_strength: "📶",
        six_pointed_star: "🔯",
        ski: "🎿",
        skier: "⛷",
        skull: "💀",
        skull_and_crossbones: "☠️",
        sleeping: "😴",
        sleeping_bed: "🛌",
        sleepy: "😪",
        slightly_frowning_face: "🙁",
        slightly_smiling_face: "🙂",
        slot_machine: "🎰",
        small_airplane: "🛩",
        small_blue_diamond: "🔹",
        small_orange_diamond: "🔸",
        small_red_triangle: "🔺",
        small_red_triangle_down: "🔻",
        smile: "😄",
        smile_cat: "😸",
        smiley: "😃",
        smiley_cat: "😺",
        smiling_imp: "😈",
        smirk: "😏",
        smirk_cat: "😼",
        smoking: "🚬",
        snail: "🐌",
        snake: "🐍",
        sneezing_face: "🤧",
        snowboarder: "🏂",
        snowflake: "❄️",
        snowman: "⛄️",
        snowman_with_snow: "☃️",
        sob: "😭",
        soccer: "⚽️",
        soon: "🔜",
        sos: "🆘",
        sound: "🔉",
        space_invader: "👾",
        spades: "♠️",
        spaghetti: "🍝",
        sparkle: "❇️",
        sparkler: "🎇",
        sparkles: "✨",
        sparkling_heart: "💖",
        speak_no_evil: "🙊",
        speaker: "🔈",
        speaking_head: "🗣",
        speech_balloon: "💬",
        speedboat: "🚤",
        spider: "🕷",
        spider_web: "🕸",
        spiral_calendar: "🗓",
        spiral_notepad: "🗒",
        spoon: "🥄",
        squid: "🦑",
        stadium: "🏟",
        star: "⭐️",
        star2: "🌟",
        star_and_crescent: "☪️",
        star_of_david: "✡️",
        stars: "🌠",
        station: "🚉",
        statue_of_liberty: "🗽",
        steam_locomotive: "🚂",
        stew: "🍲",
        stop_button: "⏹",
        stop_sign: "🛑",
        stopwatch: "⏱",
        straight_ruler: "📏",
        strawberry: "🍓",
        stuck_out_tongue: "😛",
        stuck_out_tongue_closed_eyes: "😝",
        stuck_out_tongue_winking_eye: "😜",
        studio_microphone: "🎙",
        stuffed_flatbread: "🥙",
        sun_behind_large_cloud: "🌥",
        sun_behind_rain_cloud: "🌦",
        sun_behind_small_cloud: "🌤",
        sun_with_face: "🌞",
        sunflower: "🌻",
        sunglasses: "😎",
        sunny: "☀️",
        sunrise: "🌅",
        sunrise_over_mountains: "🌄",
        surfing_man: "🏄",
        surfing_woman: "🏄&zwj;♀️",
        sushi: "🍣",
        suspension_railway: "🚟",
        sweat: "😓",
        sweat_drops: "💦",
        sweat_smile: "😅",
        sweet_potato: "🍠",
        swimming_man: "🏊",
        swimming_woman: "🏊&zwj;♀️",
        symbols: "🔣",
        synagogue: "🕍",
        syringe: "💉",
        taco: "🌮",
        tada: "🎉",
        tanabata_tree: "🎋",
        taurus: "♉️",
        taxi: "🚕",
        tea: "🍵",
        telephone_receiver: "📞",
        telescope: "🔭",
        tennis: "🎾",
        tent: "⛺️",
        thermometer: "🌡",
        thinking: "🤔",
        thought_balloon: "💭",
        ticket: "🎫",
        tickets: "🎟",
        tiger: "🐯",
        tiger2: "🐅",
        timer_clock: "⏲",
        tipping_hand_man: "💁&zwj;♂️",
        tired_face: "😫",
        tm: "™️",
        toilet: "🚽",
        tokyo_tower: "🗼",
        tomato: "🍅",
        tongue: "👅",
        top: "🔝",
        tophat: "🎩",
        tornado: "🌪",
        trackball: "🖲",
        tractor: "🚜",
        traffic_light: "🚥",
        train: "🚋",
        train2: "🚆",
        tram: "🚊",
        triangular_flag_on_post: "🚩",
        triangular_ruler: "📐",
        trident: "🔱",
        triumph: "😤",
        trolleybus: "🚎",
        trophy: "🏆",
        tropical_drink: "🍹",
        tropical_fish: "🐠",
        truck: "🚚",
        trumpet: "🎺",
        tulip: "🌷",
        tumbler_glass: "🥃",
        turkey: "🦃",
        turtle: "🐢",
        tv: "📺",
        twisted_rightwards_arrows: "🔀",
        two_hearts: "💕",
        two_men_holding_hands: "👬",
        two_women_holding_hands: "👭",
        u5272: "🈹",
        u5408: "🈴",
        u55b6: "🈺",
        u6307: "🈯️",
        u6708: "🈷️",
        u6709: "🈶",
        u6e80: "🈵",
        u7121: "🈚️",
        u7533: "🈸",
        u7981: "🈲",
        u7a7a: "🈳",
        umbrella: "☔️",
        unamused: "😒",
        underage: "🔞",
        unicorn: "🦄",
        unlock: "🔓",
        up: "🆙",
        upside_down_face: "🙃",
        v: "✌️",
        vertical_traffic_light: "🚦",
        vhs: "📼",
        vibration_mode: "📳",
        video_camera: "📹",
        video_game: "🎮",
        violin: "🎻",
        virgo: "♍️",
        volcano: "🌋",
        volleyball: "🏐",
        vs: "🆚",
        vulcan_salute: "🖖",
        walking_man: "🚶",
        walking_woman: "🚶&zwj;♀️",
        waning_crescent_moon: "🌘",
        waning_gibbous_moon: "🌖",
        warning: "⚠️",
        wastebasket: "🗑",
        watch: "⌚️",
        water_buffalo: "🐃",
        watermelon: "🍉",
        wave: "👋",
        wavy_dash: "〰️",
        waxing_crescent_moon: "🌒",
        wc: "🚾",
        weary: "😩",
        wedding: "💒",
        weight_lifting_man: "🏋️",
        weight_lifting_woman: "🏋️&zwj;♀️",
        whale: "🐳",
        whale2: "🐋",
        wheel_of_dharma: "☸️",
        wheelchair: "♿️",
        white_check_mark: "✅",
        white_circle: "⚪️",
        white_flag: "🏳️",
        white_flower: "💮",
        white_large_square: "⬜️",
        white_medium_small_square: "◽️",
        white_medium_square: "◻️",
        white_small_square: "▫️",
        white_square_button: "🔳",
        wilted_flower: "🥀",
        wind_chime: "🎐",
        wind_face: "🌬",
        wine_glass: "🍷",
        wink: "😉",
        wolf: "🐺",
        woman: "👩",
        woman_artist: "👩&zwj;🎨",
        woman_astronaut: "👩&zwj;🚀",
        woman_cartwheeling: "🤸&zwj;♀️",
        woman_cook: "👩&zwj;🍳",
        woman_facepalming: "🤦&zwj;♀️",
        woman_factory_worker: "👩&zwj;🏭",
        woman_farmer: "👩&zwj;🌾",
        woman_firefighter: "👩&zwj;🚒",
        woman_health_worker: "👩&zwj;⚕️",
        woman_judge: "👩&zwj;⚖️",
        woman_juggling: "🤹&zwj;♀️",
        woman_mechanic: "👩&zwj;🔧",
        woman_office_worker: "👩&zwj;💼",
        woman_pilot: "👩&zwj;✈️",
        woman_playing_handball: "🤾&zwj;♀️",
        woman_playing_water_polo: "🤽&zwj;♀️",
        woman_scientist: "👩&zwj;🔬",
        woman_shrugging: "🤷&zwj;♀️",
        woman_singer: "👩&zwj;🎤",
        woman_student: "👩&zwj;🎓",
        woman_teacher: "👩&zwj;🏫",
        woman_technologist: "👩&zwj;💻",
        woman_with_turban: "👳&zwj;♀️",
        womans_clothes: "👚",
        womans_hat: "👒",
        women_wrestling: "🤼&zwj;♀️",
        womens: "🚺",
        world_map: "🗺",
        worried: "😟",
        wrench: "🔧",
        writing_hand: "✍️",
        x: "❌",
        yellow_heart: "💛",
        yen: "💴",
        yin_yang: "☯️",
        yum: "😋",
        zap: "⚡️",
        zipper_mouth_face: "🤐",
        zzz: "💤",
        octocat: '<img alt=":octocat:" height="20" width="20" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/octocat.png">',
        showdown: "<span style=\"font-family: 'Anonymous Pro', monospace; text-decoration: underline; text-decoration-style: dashed; text-decoration-color: #3e8b8a;text-underline-position: under;\">S</span>"
    },
    a.Converter = function(e) {
        "use strict";
        function t(e, t) {
            if (t = t || null, a.helper.isString(e)) {
                if (e = a.helper.stdExtName(e), t = e, a.extensions[e]) return console.warn("DEPRECATION WARNING: " + e + " is an old extension that uses a deprecated loading method.Please inform the developer that the extension should be updated!"),
                void
                function(e, t) {
                    "function" == typeof e && (e = e(new a.Converter));
                    a.helper.isArray(e) || (e = [e]);
                    var n = r(e, t);
                    if (!n.valid) throw Error(n.error);
                    for (var s = 0; s < e.length; ++s) switch (e[s].type) {
                    case "lang":
                        u.push(e[s]);
                        break;
                    case "output":
                        d.push(e[s]);
                        break;
                    default:
                        throw Error("Extension loader error: Type unrecognized!!!")
                    }
                } (a.extensions[e], e);
                if (a.helper.isUndefined(s[e])) throw Error('Extension "' + e + '" could not be loaded. It was either not found or is not a valid extension.');
                e = s[e]
            }
            "function" == typeof e && (e = e()),
            a.helper.isArray(e) || (e = [e]);
            var o = r(e, t);
            if (!o.valid) throw Error(o.error);
            for (var i = 0; i < e.length; ++i) {
                switch (e[i].type) {
                case "lang":
                    u.push(e[i]);
                    break;
                case "output":
                    d.push(e[i])
                }
                if (e[i].hasOwnProperty("listeners")) for (var l in e[i].listeners) e[i].listeners.hasOwnProperty(l) && n(l, e[i].listeners[l])
            }
        }
        function n(e, r) {
            if (!a.helper.isString(e)) throw Error("Invalid argument in converter.listen() method: name must be a string, but " + typeof e + " given");
            if ("function" != typeof r) throw Error("Invalid argument in converter.listen() method: callback must be a function, but " + typeof r + " given");
            p.hasOwnProperty(e) || (p[e] = []),
            p[e].push(r)
        }
        var c = {},
        u = [],
        d = [],
        p = {},
        h = i,
        _ = {
            parsed: {},
            raw: "",
            format: ""
        }; !
        function() {
            e = e || {};
            for (var r in o) o.hasOwnProperty(r) && (c[r] = o[r]);
            if ("object" != typeof e) throw Error("Converter expects the passed parameter to be an object, but " + typeof e + " was passed instead.");
            for (var n in e) e.hasOwnProperty(n) && (c[n] = e[n]);
            c.extensions && a.helper.forEach(c.extensions, t)
        } (),
        this._dispatch = function(e, r, t, a) {
            if (p.hasOwnProperty(e)) for (var n = 0; n < p[e].length; ++n) {
                var s = p[e][n](e, r, this, t, a);
                s && void 0 !== s && (r = s)
            }
            return r
        },
        this.listen = function(e, r) {
            return n(e, r),
            this
        },
        this.makeHtml = function(e) {
            if (!e) return e;
            var r = {
                gHtmlBlocks: [],
                gHtmlMdBlocks: [],
                gHtmlSpans: [],
                gUrls: {},
                gTitles: {},
                gDimensions: {},
                gListLevel: 0,
                hashLinkCounts: {},
                langExtensions: u,
                outputModifiers: d,
                converter: this,
                ghCodeBlocks: [],
                metadata: {
                    parsed: {},
                    raw: "",
                    format: ""
                }
            };
            return e = e.replace(/¨/g, "¨T"),
            e = e.replace(/\$/g, "¨D"),
            e = e.replace(/\r\n/g, "\n"),
            e = e.replace(/\r/g, "\n"),
            e = e.replace(/\u00A0/g, "&nbsp;"),
            c.smartIndentationFix && (e = function(e) {
                var r = e.match(/^\s*/)[0].length,
                t = new RegExp("^\\s{0," + r + "}", "gm");
                return e.replace(t, "")
            } (e)),
            e = "\n\n" + e + "\n\n",
            e = a.subParser("detab")(e, c, r),
            e = e.replace(/^[ \t]+$/gm, ""),
            a.helper.forEach(u,
            function(t) {
                e = a.subParser("runExtension")(t, e, c, r)
            }),
            e = a.subParser("metadata")(e, c, r),
            e = a.subParser("hashPreCodeTags")(e, c, r),
            e = a.subParser("githubCodeBlocks")(e, c, r),
            e = a.subParser("hashHTMLBlocks")(e, c, r),
            e = a.subParser("hashCodeTags")(e, c, r),
            e = a.subParser("stripLinkDefinitions")(e, c, r),
            e = a.subParser("blockGamut")(e, c, r),
            e = a.subParser("unhashHTMLSpans")(e, c, r),
            e = a.subParser("unescapeSpecialChars")(e, c, r),
            e = e.replace(/¨D/g, "$$"),
            e = e.replace(/¨T/g, "¨"),
            e = a.subParser("completeHTMLDocument")(e, c, r),
            a.helper.forEach(d,
            function(t) {
                e = a.subParser("runExtension")(t, e, c, r)
            }),
            _ = r.metadata,
            e
        },
        this.makeMarkdown = this.makeMd = function(e, r) {
            function t(e) {
                for (var r = 0; r < e.childNodes.length; ++r) {
                    var a = e.childNodes[r];
                    3 === a.nodeType ? /\S/.test(a.nodeValue) ? (a.nodeValue = a.nodeValue.split("\n").join(" "), a.nodeValue = a.nodeValue.replace(/(\s)+/g, "$1")) : (e.removeChild(a), --r) : 1 === a.nodeType && t(a)
                }
            }
            if (e = e.replace(/\r\n/g, "\n"), e = e.replace(/\r/g, "\n"), e = e.replace(/>[ \t]+</, ">¨NBSP;<"), !r) {
                if (!window || !window.document) throw new Error("HTMLParser is undefined. If in a webworker or nodejs environment, you need to provide a WHATWG DOM and HTML such as JSDOM");
                r = window.document
            }
            var n = r.createElement("div");
            n.innerHTML = e;
            var s = {
                preList: function(e) {
                    for (var r = e.querySelectorAll("pre"), t = [], n = 0; n < r.length; ++n) if (1 === r[n].childElementCount && "code" === r[n].firstChild.tagName.toLowerCase()) {
                        var s = r[n].firstChild.innerHTML.trim(),
                        o = r[n].firstChild.getAttribute("data-language") || "";
                        if ("" === o) for (var i = r[n].firstChild.className.split(" "), l = 0; l < i.length; ++l) {
                            var c = i[l].match(/^language-(.+)$/);
                            if (null !== c) {
                                o = c[1];
                                break
                            }
                        }
                        s = a.helper.unescapeHTMLEntities(s),
                        t.push(s),
                        r[n].outerHTML = '<precode language="' + o + '" precodenum="' + n.toString() + '"></precode>'
                    } else t.push(r[n].innerHTML),
                    r[n].innerHTML = "",
                    r[n].setAttribute("prenum", n.toString());
                    return t
                } (n)
            };
            t(n);
            for (var o = n.childNodes,
            i = "",
            l = 0; l < o.length; l++) i += a.subParser("makeMarkdown.node")(o[l], s);
            return i
        },
        this.setOption = function(e, r) {
            c[e] = r
        },
        this.getOption = function(e) {
            return c[e]
        },
        this.getOptions = function() {
            return c
        },
        this.addExtension = function(e, r) {
            t(e, r = r || null)
        },
        this.useExtension = function(e) {
            t(e)
        },
        this.setFlavor = function(e) {
            if (!l.hasOwnProperty(e)) throw Error(e + " flavor was not found");
            var r = l[e];
            h = e;
            for (var t in r) r.hasOwnProperty(t) && (c[t] = r[t])
        },
        this.getFlavor = function() {
            return h
        },
        this.removeExtension = function(e) {
            a.helper.isArray(e) || (e = [e]);
            for (var r = 0; r < e.length; ++r) {
                for (var t = e[r], n = 0; n < u.length; ++n) u[n] === t && u[n].splice(n, 1);
                for (; 0 < d.length; ++n) d[0] === t && d[0].splice(n, 1)
            }
        },
        this.getAllExtensions = function() {
            return {
                language: u,
                output: d
            }
        },
        this.getMetadata = function(e) {
            return e ? _.raw: _.parsed
        },
        this.getMetadataFormat = function() {
            return _.format
        },
        this._setMetadataPair = function(e, r) {
            _.parsed[e] = r
        },
        this._setMetadataFormat = function(e) {
            _.format = e
        },
        this._setMetadataRaw = function(e) {
            _.raw = e
        }
    },
    a.subParser("anchors",
    function(e, r, t) {
        "use strict";
        var n = function(e, n, s, o, i, l, c) {
            if (a.helper.isUndefined(c) && (c = ""), s = s.toLowerCase(), e.search(/\(<?\s*>? ?(['"].*['"])?\)$/m) > -1) o = "";
            else if (!o) {
                if (s || (s = n.toLowerCase().replace(/ ?\n/g, " ")), o = "#" + s, a.helper.isUndefined(t.gUrls[s])) return e;
                o = t.gUrls[s],
                a.helper.isUndefined(t.gTitles[s]) || (c = t.gTitles[s])
            }
            var u = '<a href="' + (o = o.replace(a.helper.regexes.asteriskDashAndColon, a.helper.escapeCharactersCallback)) + '"';
            return "" !== c && null !== c && (u += ' title="' + (c = (c = c.replace(/"/g, "&quot;")).replace(a.helper.regexes.asteriskDashAndColon, a.helper.escapeCharactersCallback)) + '"'),
            r.openLinksInNewWindow && !/^#/.test(o) && (u += ' rel="noopener noreferrer" target="¨E95Eblank"'),
            u += ">" + n + "</a>"
        };
        return e = (e = t.converter._dispatch("anchors.before", e, r, t)).replace(/\[((?:\[[^\]]*]|[^\[\]])*)] ?(?:\n *)?\[(.*?)]()()()()/g, n),
        e = e.replace(/\[((?:\[[^\]]*]|[^\[\]])*)]()[ \t]*\([ \t]?<([^>]*)>(?:[ \t]*((["'])([^"]*?)\5))?[ \t]?\)/g, n),
        e = e.replace(/\[((?:\[[^\]]*]|[^\[\]])*)]()[ \t]*\([ \t]?<?([\S]+?(?:\([\S]*?\)[\S]*?)?)>?(?:[ \t]*((["'])([^"]*?)\5))?[ \t]?\)/g, n),
        e = e.replace(/\[([^\[\]]+)]()()()()()/g, n),
        r.ghMentions && (e = e.replace(/(^|\s)(\\)?(@([a-z\d]+(?:[a-z\d.-]+?[a-z\d]+)*))/gim,
        function(e, t, n, s, o) {
            if ("\\" === n) return t + s;
            if (!a.helper.isString(r.ghMentionsLink)) throw new Error("ghMentionsLink option must be a string");
            var i = r.ghMentionsLink.replace(/\{u}/g, o),
            l = "";
            return r.openLinksInNewWindow && (l = ' rel="noopener noreferrer" target="¨E95Eblank"'),
            t + '<a href="' + i + '"' + l + ">" + s + "</a>"
        })),
        e = t.converter._dispatch("anchors.after", e, r, t)
    });
    var u = /([*~_]+|\b)(((https?|ftp|dict):\/\/|www\.)[^'">\s]+?\.[^'">\s]+?)()(\1)?(?=\s|$)(?!["<>])/gi,
    d = /([*~_]+|\b)(((https?|ftp|dict):\/\/|www\.)[^'">\s]+\.[^'">\s]+?)([.!?,()\[\]])?(\1)?(?=\s|$)(?!["<>])/gi,
    p = /()<(((https?|ftp|dict):\/\/|www\.)[^'">\s]+)()>()/gi,
    h = /(^|\s)(?:mailto:)?([A-Za-z0-9!#$%&'*+-/ = ?^_` { |
    }~.] + @ [ - a - z0 - 9] + (\. [ - a - z0 - 9] + ) * \. [a - z] + )( ? =$ | \s) / gim,
    _ = /<()(?:mailto:)?([-.\w]+@[-a-z0-9]+(\.[-a-z0-9]+)*\.[a-z]+)>/gi,
    g = function(e) {
        "use strict";
        return function(r, t, n, s, o, i, l) {
            var c = n = n.replace(a.helper.regexes.asteriskDashAndColon, a.helper.escapeCharactersCallback),
            u = "",
            d = "",
            p = t || "",
            h = l || "";
            return /^www\./i.test(n) && (n = n.replace(/^www\./i, "http://www.")),
            e.excludeTrailingPunctuationFromURLs && i && (u = i),
            e.openLinksInNewWindow && (d = ' rel="noopener noreferrer" target="¨E95Eblank"'),
            p + '<a href="' + n + '"' + d + ">" + c + "</a>" + u + h
        }
    },
    m = function(e, r) {
        "use strict";
        return function(t, n, s) {
            var o = "mailto:";
            return n = n || "",
            s = a.subParser("unescapeSpecialChars")(s, e, r),
            e.encodeEmails ? (o = a.helper.encodeEmailAddress(o + s), s = a.helper.encodeEmailAddress(s)) : o += s,
            n + '<a href="' + o + '">' + s + "</a>"
        }
    };
    a.subParser("autoLinks",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("autoLinks.before", e, r, t),
        e = e.replace(p, g(r)),
        e = e.replace(_, m(r, t)),
        e = t.converter._dispatch("autoLinks.after", e, r, t)
    }),
    a.subParser("simplifiedAutoLinks",
    function(e, r, t) {
        "use strict";
        return r.simplifiedAutoLink ? (e = t.converter._dispatch("simplifiedAutoLinks.before", e, r, t), e = r.excludeTrailingPunctuationFromURLs ? e.replace(d, g(r)) : e.replace(u, g(r)), e = e.replace(h, m(r, t)), e = t.converter._dispatch("simplifiedAutoLinks.after", e, r, t)) : e
    }),
    a.subParser("blockGamut",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("blockGamut.before", e, r, t),
        e = a.subParser("blockQuotes")(e, r, t),
        e = a.subParser("headers")(e, r, t),
        e = a.subParser("horizontalRule")(e, r, t),
        e = a.subParser("lists")(e, r, t),
        e = a.subParser("codeBlocks")(e, r, t),
        e = a.subParser("tables")(e, r, t),
        e = a.subParser("hashHTMLBlocks")(e, r, t),
        e = a.subParser("paragraphs")(e, r, t),
        e = t.converter._dispatch("blockGamut.after", e, r, t)
    }),
    a.subParser("blockQuotes",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("blockQuotes.before", e, r, t),
        e += "\n\n";
        var n = /(^ {0,3}>[ \t]?.+\n(.+\n)*\n*)+/gm;
        return r.splitAdjacentBlockquotes && (n = /^ {0,3}>[\s\S]*?(?:\n\n)/gm),
        e = e.replace(n,
        function(e) {
            return e = e.replace(/^[ \t]*>[ \t]?/gm, ""),
            e = e.replace(/¨0/g, ""),
            e = e.replace(/^[ \t]+$/gm, ""),
            e = a.subParser("githubCodeBlocks")(e, r, t),
            e = a.subParser("blockGamut")(e, r, t),
            e = e.replace(/(^|\n)/g, "$1  "),
            e = e.replace(/(\s*<pre>[^\r]+?<\/pre>)/gm,
            function(e, r) {
                var t = r;
                return t = t.replace(/^  /gm, "¨0"),
                t = t.replace(/¨0/g, "")
            }),
            a.subParser("hashBlock")("<blockquote>\n" + e + "\n</blockquote>", r, t)
        }),
        e = t.converter._dispatch("blockQuotes.after", e, r, t)
    }),
    a.subParser("codeBlocks",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("codeBlocks.before", e, r, t);
        return e = (e += "¨0").replace(/(?:\n\n|^)((?:(?:[ ]{4}|\t).*\n+)+)(\n*[ ]{0,3}[^ \t\n]|(?=¨0))/g,
        function(e, n, s) {
            var o = n,
            i = s,
            l = "\n";
            return o = a.subParser("outdent")(o, r, t),
            o = a.subParser("encodeCode")(o, r, t),
            o = a.subParser("detab")(o, r, t),
            o = o.replace(/^\n+/g, ""),
            o = o.replace(/\n+$/g, ""),
            r.omitExtraWLInCodeBlocks && (l = ""),
            o = "<pre><code>" + o + l + "</code></pre>",
            a.subParser("hashBlock")(o, r, t) + i
        }),
        e = e.replace(/¨0/, ""),
        e = t.converter._dispatch("codeBlocks.after", e, r, t)
    }),
    a.subParser("codeSpans",
    function(e, r, t) {
        "use strict";
        return void 0 === (e = t.converter._dispatch("codeSpans.before", e, r, t)) && (e = ""),
        e = e.replace(/(^|[^\\])(`+)([^\r]*?[^`])\2(?!`)/gm,
        function(e, n, s, o) {
            var i = o;
            return i = i.replace(/^([ \t]*)/g, ""),
            i = i.replace(/[ \t]*$/g, ""),
            i = a.subParser("encodeCode")(i, r, t),
            i = n + "<code>" + i + "</code>",
            i = a.subParser("hashHTMLSpans")(i, r, t)
        }),
        e = t.converter._dispatch("codeSpans.after", e, r, t)
    }),
    a.subParser("completeHTMLDocument",
    function(e, r, t) {
        "use strict";
        if (!r.completeHTMLDocument) return e;
        e = t.converter._dispatch("completeHTMLDocument.before", e, r, t);
        var a = "html",
        n = "<!DOCTYPE HTML>\n",
        s = "",
        o = '<meta charset="utf-8">\n',
        i = "",
        l = "";
        void 0 !== t.metadata.parsed.doctype && (n = "<!DOCTYPE " + t.metadata.parsed.doctype + ">\n", "html" !== (a = t.metadata.parsed.doctype.toString().toLowerCase()) && "html5" !== a || (o = '<meta charset="utf-8">'));
        for (var c in t.metadata.parsed) if (t.metadata.parsed.hasOwnProperty(c)) switch (c.toLowerCase()) {
        case "doctype":
            break;
        case "title":
            s = "<title>" + t.metadata.parsed.title + "</title>\n";
            break;
        case "charset":
            o = "html" === a || "html5" === a ? '<meta charset="' + t.metadata.parsed.charset + '">\n': '<meta name="charset" content="' + t.metadata.parsed.charset + '">\n';
            break;
        case "language":
        case "lang":
            i = ' lang="' + t.metadata.parsed[c] + '"',
            l += '<meta name="' + c + '" content="' + t.metadata.parsed[c] + '">\n';
            break;
        default:
            l += '<meta name="' + c + '" content="' + t.metadata.parsed[c] + '">\n'
        }
        return e = n + "<html" + i + ">\n<head>\n" + s + o + l + "</head>\n<body>\n" + e.trim() + "\n</body>\n</html>",
        e = t.converter._dispatch("completeHTMLDocument.after", e, r, t)
    }),
    a.subParser("detab",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("detab.before", e, r, t),
        e = e.replace(/\t(?=\t)/g, "    "),
        e = e.replace(/\t/g, "¨A¨B"),
        e = e.replace(/¨B(.+?)¨A/g,
        function(e, r) {
            for (var t = r,
            a = 4 - t.length % 4,
            n = 0; n < a; n++) t += " ";
            return t
        }),
        e = e.replace(/¨A/g, "    "),
        e = e.replace(/¨B/g, ""),
        e = t.converter._dispatch("detab.after", e, r, t)
    }),
    a.subParser("ellipsis",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("ellipsis.before", e, r, t),
        e = e.replace(/\.\.\./g, "…"),
        e = t.converter._dispatch("ellipsis.after", e, r, t)
    }),
    a.subParser("emoji",
    function(e, r, t) {
        "use strict";
        if (!r.emoji) return e;
        return e = (e = t.converter._dispatch("emoji.before", e, r, t)).replace(/:([\S]+?):/g,
        function(e, r) {
            return a.helper.emojis.hasOwnProperty(r) ? a.helper.emojis[r] : e
        }),
        e = t.converter._dispatch("emoji.after", e, r, t)
    }),
    a.subParser("encodeAmpsAndAngles",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("encodeAmpsAndAngles.before", e, r, t),
        e = e.replace(/&(?!#?[xX]?(?:[0-9a-fA-F]+|\w+);)/g, "&amp;"),
        e = e.replace(/<(?![a-z\/?$!])/gi, "&lt;"),
        e = e.replace(/</g, "&lt;"),
        e = e.replace(/>/g, "&gt;"),
        e = t.converter._dispatch("encodeAmpsAndAngles.after", e, r, t)
    }),
    a.subParser("encodeBackslashEscapes",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("encodeBackslashEscapes.before", e, r, t),
        e = e.replace(/\\(\\)/g, a.helper.escapeCharactersCallback),
        e = e.replace(/\\([`*_{}\[\]()>#+.!~=|-])/g, a.helper.escapeCharactersCallback),
        e = t.converter._dispatch("encodeBackslashEscapes.after", e, r, t)
    }),
    a.subParser("encodeCode",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("encodeCode.before", e, r, t),
        e = e.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/([*_{}\[\]\\=~-])/g, a.helper.escapeCharactersCallback),
        e = t.converter._dispatch("encodeCode.after", e, r, t)
    }),
    a.subParser("escapeSpecialCharsWithinTagAttributes",
    function(e, r, t) {
        "use strict";
        return e = (e = t.converter._dispatch("escapeSpecialCharsWithinTagAttributes.before", e, r, t)).replace(/<\/?[a-z\d_:-]+(?:[\s]+[\s\S]+?)?>/gi,
        function(e) {
            return e.replace(/(.)<\/?code>(?=.)/g, "$1`").replace(/([\\`*_~=|])/g, a.helper.escapeCharactersCallback)
        }),
        e = e.replace(/<!(--(?:(?:[^>-]|-[^>])(?:[^-]|-[^-])*)--)>/gi,
        function(e) {
            return e.replace(/([\\`*_~=|])/g, a.helper.escapeCharactersCallback)
        }),
        e = t.converter._dispatch("escapeSpecialCharsWithinTagAttributes.after", e, r, t)
    }),
    a.subParser("githubCodeBlocks",
    function(e, r, t) {
        "use strict";
        return r.ghCodeBlocks ? (e = t.converter._dispatch("githubCodeBlocks.before", e, r, t), e += "¨0", e = e.replace(/(?:^|\n)(?: {0,3})(```+|~~~+)(?: *)([^\s`~]*)\n([\s\S]*?)\n(?: {0,3})\1/g,
        function(e, n, s, o) {
            var i = r.omitExtraWLInCodeBlocks ? "": "\n";
            return o = a.subParser("encodeCode")(o, r, t),
            o = a.subParser("detab")(o, r, t),
            o = o.replace(/^\n+/g, ""),
            o = o.replace(/\n+$/g, ""),
            o = "<pre><code" + (s ? ' class="' + s + " language-" + s + '"': "") + ">" + o + i + "</code></pre>",
            o = a.subParser("hashBlock")(o, r, t),
            "\n\n¨G" + (t.ghCodeBlocks.push({
                text: e,
                codeblock: o
            }) - 1) + "G\n\n"
        }), e = e.replace(/¨0/, ""), t.converter._dispatch("githubCodeBlocks.after", e, r, t)) : e
    }),
    a.subParser("hashBlock",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("hashBlock.before", e, r, t),
        e = e.replace(/(^\n+|\n+$)/g, ""),
        e = "\n\n¨K" + (t.gHtmlBlocks.push(e) - 1) + "K\n\n",
        e = t.converter._dispatch("hashBlock.after", e, r, t)
    }),
    a.subParser("hashCodeTags",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("hashCodeTags.before", e, r, t);
        return e = a.helper.replaceRecursiveRegExp(e,
        function(e, n, s, o) {
            var i = s + a.subParser("encodeCode")(n, r, t) + o;
            return "¨C" + (t.gHtmlSpans.push(i) - 1) + "C"
        },
        "<code\\b[^>]*>", "</code>", "gim"),
        e = t.converter._dispatch("hashCodeTags.after", e, r, t)
    }),
    a.subParser("hashElement",
    function(e, r, t) {
        "use strict";
        return function(e, r) {
            var a = r;
            return a = a.replace(/\n\n/g, "\n"),
            a = a.replace(/^\n/, ""),
            a = a.replace(/\n+$/g, ""),
            a = "\n\n¨K" + (t.gHtmlBlocks.push(a) - 1) + "K\n\n"
        }
    }),
    a.subParser("hashHTMLBlocks",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("hashHTMLBlocks.before", e, r, t);
        var n = ["pre", "div", "h1", "h2", "h3", "h4", "h5", "h6", "blockquote", "table", "dl", "ol", "ul", "script", "noscript", "form", "fieldset", "iframe", "math", "style", "section", "header", "footer", "nav", "article", "aside", "address", "audio", "canvas", "figure", "hgroup", "output", "video", "p"],
        s = function(e, r, a, n) {
            var s = e;
            return - 1 !== a.search(/\bmarkdown\b/) && (s = a + t.converter.makeHtml(r) + n),
            "\n\n¨K" + (t.gHtmlBlocks.push(s) - 1) + "K\n\n"
        };
        r.backslashEscapesHTMLTags && (e = e.replace(/\\<(\/?[^>]+?)>/g,
        function(e, r) {
            return "&lt;" + r + "&gt;"
        }));
        for (var o = 0; o < n.length; ++o) for (var i, l = new RegExp("^ {0,3}(<" + n[o] + "\\b[^>]*>)", "im"), c = "<" + n[o] + "\\b[^>]*>", u = "</" + n[o] + ">"; - 1 !== (i = a.helper.regexIndexOf(e, l));) {
            var d = a.helper.splitAtIndex(e, i),
            p = a.helper.replaceRecursiveRegExp(d[1], s, c, u, "im");
            if (p === d[1]) break;
            e = d[0].concat(p)
        }
        return e = e.replace(/(\n {0,3}(<(hr)\b([^<>])*?\/?>)[ \t]*(?=\n{2,}))/g, a.subParser("hashElement")(e, r, t)),
        e = a.helper.replaceRecursiveRegExp(e,
        function(e) {
            return "\n\n¨K" + (t.gHtmlBlocks.push(e) - 1) + "K\n\n"
        },
        "^ {0,3}\x3c!--", "--\x3e", "gm"),
        e = e.replace(/(?:\n\n)( {0,3}(?:<([?%])[^\r]*?\2>)[ \t]*(?=\n{2,}))/g, a.subParser("hashElement")(e, r, t)),
        e = t.converter._dispatch("hashHTMLBlocks.after", e, r, t)
    }),
    a.subParser("hashHTMLSpans",
    function(e, r, t) {
        "use strict";
        function a(e) {
            return "¨C" + (t.gHtmlSpans.push(e) - 1) + "C"
        }
        return e = t.converter._dispatch("hashHTMLSpans.before", e, r, t),
        e = e.replace(/<[^>]+?\/>/gi,
        function(e) {
            return a(e)
        }),
        e = e.replace(/<([^>]+?)>[\s\S]*?<\/\1>/g,
        function(e) {
            return a(e)
        }),
        e = e.replace(/<([^>]+?)\s[^>]+?>[\s\S]*?<\/\1>/g,
        function(e) {
            return a(e)
        }),
        e = e.replace(/<[^>]+?>/gi,
        function(e) {
            return a(e)
        }),
        e = t.converter._dispatch("hashHTMLSpans.after", e, r, t)
    }),
    a.subParser("unhashHTMLSpans",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("unhashHTMLSpans.before", e, r, t);
        for (var a = 0; a < t.gHtmlSpans.length; ++a) {
            for (var n = t.gHtmlSpans[a], s = 0;
            /¨C(\d+)C/.test(n);) {
                var o = RegExp.$1;
                if (n = n.replace("¨C" + o + "C", t.gHtmlSpans[o]), 10 === s) {
                    console.error("maximum nesting of 10 spans reached!!!");
                    break
                }++s
            }
            e = e.replace("¨C" + a + "C", n)
        }
        return e = t.converter._dispatch("unhashHTMLSpans.after", e, r, t)
    }),
    a.subParser("hashPreCodeTags",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("hashPreCodeTags.before", e, r, t);
        return e = a.helper.replaceRecursiveRegExp(e,
        function(e, n, s, o) {
            var i = s + a.subParser("encodeCode")(n, r, t) + o;
            return "\n\n¨G" + (t.ghCodeBlocks.push({
                text: e,
                codeblock: i
            }) - 1) + "G\n\n"
        },
        "^ {0,3}<pre\\b[^>]*>\\s*<code\\b[^>]*>", "^ {0,3}</code>\\s*</pre>", "gim"),
        e = t.converter._dispatch("hashPreCodeTags.after", e, r, t)
    }),
    a.subParser("headers",
    function(e, r, t) {
        "use strict";
        function n(e) {
            var n, s;
            if (r.customizedHeaderId) {
                var o = e.match(/\{([^{]+?)}\s*$/);
                o && o[1] && (e = o[1])
            }
            return n = e,
            s = a.helper.isString(r.prefixHeaderId) ? r.prefixHeaderId: !0 === r.prefixHeaderId ? "section-": "",
            r.rawPrefixHeaderId || (n = s + n),
            n = r.ghCompatibleHeaderId ? n.replace(/ /g, "-").replace(/&amp;/g, "").replace(/¨T/g, "").replace(/¨D/g, "").replace(/[&+$,\/:;=?@"#{}|^¨~\[\]`\\*)(%.!'<>]/g, "").toLowerCase() : r.rawHeaderId ? n.replace(/ /g, "-").replace(/&amp;/g, "&").replace(/¨T/g, "¨").replace(/¨D/g, "$").replace(/["']/g, "-").toLowerCase() : n.replace(/[^\w]/g, "").toLowerCase(),
            r.rawPrefixHeaderId && (n = s + n),
            t.hashLinkCounts[n] ? n = n + "-" + t.hashLinkCounts[n]++:t.hashLinkCounts[n] = 1,
            n
        }
        e = t.converter._dispatch("headers.before", e, r, t);
        var s = isNaN(parseInt(r.headerLevelStart)) ? 1 : parseInt(r.headerLevelStart),
        o = r.smoothLivePreview ? /^(.+)[ \t]*\n={2,}[ \t]*\n+/gm: /^(.+)[ \t]*\n=+[ \t]*\n+/gm,
        i = r.smoothLivePreview ? /^(.+)[ \t]*\n-{2,}[ \t]*\n+/gm: /^(.+)[ \t]*\n-+[ \t]*\n+/gm;
        e = (e = e.replace(o,
        function(e, o) {
            var i = a.subParser("spanGamut")(o, r, t),
            l = r.noHeaderId ? "": ' id="' + n(o) + '"',
            c = "<h" + s + l + ">" + i + "</h" + s + ">";
            return a.subParser("hashBlock")(c, r, t)
        })).replace(i,
        function(e, o) {
            var i = a.subParser("spanGamut")(o, r, t),
            l = r.noHeaderId ? "": ' id="' + n(o) + '"',
            c = s + 1,
            u = "<h" + c + l + ">" + i + "</h" + c + ">";
            return a.subParser("hashBlock")(u, r, t)
        });
        var l = r.requireSpaceBeforeHeadingText ? /^(#{1,6})[ \t]+(.+?)[ \t]*#*\n+/gm: /^(#{1,6})[ \t]*(.+?)[ \t]*#*\n+/gm;
        return e = e.replace(l,
        function(e, o, i) {
            var l = i;
            r.customizedHeaderId && (l = i.replace(/\s?\{([^{]+?)}\s*$/, ""));
            var c = a.subParser("spanGamut")(l, r, t),
            u = r.noHeaderId ? "": ' id="' + n(i) + '"',
            d = s - 1 + o.length,
            p = "<h" + d + u + ">" + c + "</h" + d + ">";
            return a.subParser("hashBlock")(p, r, t)
        }),
        e = t.converter._dispatch("headers.after", e, r, t)
    }),
    a.subParser("horizontalRule",
    function(e, r, t) {
        "use strict";
        e = t.converter._dispatch("horizontalRule.before", e, r, t);
        var n = a.subParser("hashBlock")("<hr />", r, t);
        return e = e.replace(/^ {0,2}( ?-){3,}[ \t]*$/gm, n),
        e = e.replace(/^ {0,2}( ?\*){3,}[ \t]*$/gm, n),
        e = e.replace(/^ {0,2}( ?_){3,}[ \t]*$/gm, n),
        e = t.converter._dispatch("horizontalRule.after", e, r, t)
    }),
    a.subParser("images",
    function(e, r, t) {
        "use strict";
        function n(e, r, n, s, o, i, l, c) {
            var u = t.gUrls,
            d = t.gTitles,
            p = t.gDimensions;
            if (n = n.toLowerCase(), c || (c = ""), e.search(/\(<?\s*>? ?(['"].*['"])?\)$/m) > -1) s = "";
            else if ("" === s || null === s) {
                if ("" !== n && null !== n || (n = r.toLowerCase().replace(/ ?\n/g, " ")), s = "#" + n, a.helper.isUndefined(u[n])) return e;
                s = u[n],
                a.helper.isUndefined(d[n]) || (c = d[n]),
                a.helper.isUndefined(p[n]) || (o = p[n].width, i = p[n].height)
            }
            r = r.replace(/"/g, "&quot;").replace(a.helper.regexes.asteriskDashAndColon, a.helper.escapeCharactersCallback);
            var h = '<img src="' + (s = s.replace(a.helper.regexes.asteriskDashAndColon, a.helper.escapeCharactersCallback)) + '" alt="' + r + '"';
            return c && a.helper.isString(c) && (h += ' title="' + (c = c.replace(/"/g, "&quot;").replace(a.helper.regexes.asteriskDashAndColon, a.helper.escapeCharactersCallback)) + '"'),
            o && i && (h += ' width="' + (o = "*" === o ? "auto": o) + '"', h += ' height="' + (i = "*" === i ? "auto": i) + '"'),
            h += " />"
        }
        return e = (e = t.converter._dispatch("images.before", e, r, t)).replace(/!\[([^\]]*?)] ?(?:\n *)?\[([\s\S]*?)]()()()()()/g, n),
        e = e.replace(/!\[([^\]]*?)][ \t]*()\([ \t]?<?(data:.+?\/.+?;base64,[A-Za-z0-9+/ = \n] + ?) > ?( ? :=([ * \d] + [A - Za - z % ] {
            0,
            4
        }) x([ * \d] + [A - Za - z % ] {
            0,
            4
        })) ? [\t] * ( ? :(["'])([^"] * ?)\6) ? [\t] ? \) / g,
        function(e, r, t, a, s, o, i, l) {
            return a = a.replace(/\s/g, ""),
            n(e, r, t, a, s, o, 0, l)
        }),
        e = e.replace(/!\[([^\]]*?)][ \t]*()\([ \t]?<([^>]*)>(?: =([*\d]+[A-Za-z%]{0,4})x([*\d]+[A-Za-z%]{0,4}))?[ \t]*(?:(?:(["'])([^"]*?)\6))?[ \t]?\)/g, n),
        e = e.replace(/!\[([^\]]*?)][ \t]*()\([ \t]?<?([\S]+?(?:\([\S]*?\)[\S]*?)?)>?(?: =([*\d]+[A-Za-z%]{0,4})x([*\d]+[A-Za-z%]{0,4}))?[ \t]*(?:(["'])([^"]*?)\6)?[ \t]?\)/g, n),
        e = e.replace(/!\[([^\[\]]+)]()()()()()/g, n),
        e = t.converter._dispatch("images.after", e, r, t)
    }), a.subParser("italicsAndBold",
    function(e, r, t) {
        "use strict";
        function a(e, r, t) {
            return r + e + t
        }
        return e = t.converter._dispatch("italicsAndBold.before", e, r, t),
        e = r.literalMidWordUnderscores ? (e = (e = e.replace(/\b___(\S[\s\S]*?)___\b/g,
        function(e, r) {
            return a(r, "<strong><em>", "</em></strong>")
        })).replace(/\b__(\S[\s\S]*?)__\b/g,
        function(e, r) {
            return a(r, "<strong>", "</strong>")
        })).replace(/\b_(\S[\s\S]*?)_\b/g,
        function(e, r) {
            return a(r, "<em>", "</em>")
        }) : (e = (e = e.replace(/___(\S[\s\S]*?)___/g,
        function(e, r) {
            return /\S$/.test(r) ? a(r, "<strong><em>", "</em></strong>") : e
        })).replace(/__(\S[\s\S]*?)__/g,
        function(e, r) {
            return /\S$/.test(r) ? a(r, "<strong>", "</strong>") : e
        })).replace(/_([^\s_][\s\S]*?)_/g,
        function(e, r) {
            return /\S$/.test(r) ? a(r, "<em>", "</em>") : e
        }),
        e = r.literalMidWordAsterisks ? (e = (e = e.replace(/([^*]|^)\B\*\*\*(\S[\s\S]*?)\*\*\*\B(?!\*)/g,
        function(e, r, t) {
            return a(t, r + "<strong><em>", "</em></strong>")
        })).replace(/([^*]|^)\B\*\*(\S[\s\S]*?)\*\*\B(?!\*)/g,
        function(e, r, t) {
            return a(t, r + "<strong>", "</strong>")
        })).replace(/([^*]|^)\B\*(\S[\s\S]*?)\*\B(?!\*)/g,
        function(e, r, t) {
            return a(t, r + "<em>", "</em>")
        }) : (e = (e = e.replace(/\*\*\*(\S[\s\S]*?)\*\*\*/g,
        function(e, r) {
            return /\S$/.test(r) ? a(r, "<strong><em>", "</em></strong>") : e
        })).replace(/\*\*(\S[\s\S]*?)\*\*/g,
        function(e, r) {
            return /\S$/.test(r) ? a(r, "<strong>", "</strong>") : e
        })).replace(/\*([^\s*][\s\S]*?)\*/g,
        function(e, r) {
            return /\S$/.test(r) ? a(r, "<em>", "</em>") : e
        }),
        e = t.converter._dispatch("italicsAndBold.after", e, r, t)
    }), a.subParser("lists",
    function(e, r, t) {
        "use strict";
        function n(e, n) {
            t.gListLevel++,
            e = e.replace(/\n{2,}$/, "\n");
            var s = /(\n)?(^ {0,3})([*+-]|\d+[.])[ \t]+((\[(x|X| )?])?[ \t]*[^\r]+?(\n{1,2}))(?=\n*(¨0| {0,3}([*+-]|\d+[.])[ \t]+))/gm,
            o = /\n[ \t]*\n(?!¨0)/.test(e += "¨0");
            return r.disableForced4SpacesIndentedSublists && (s = /(\n)?(^ {0,3})([*+-]|\d+[.])[ \t]+((\[(x|X| )?])?[ \t]*[^\r]+?(\n{1,2}))(?=\n*(¨0|\2([*+-]|\d+[.])[ \t]+))/gm),
            e = e.replace(s,
            function(e, n, s, i, l, c, u) {
                u = u && "" !== u.trim();
                var d = a.subParser("outdent")(l, r, t),
                p = "";
                return c && r.tasklists && (p = ' class="task-list-item" style="list-style-type: none;"', d = d.replace(/^[ \t]*\[(x|X| )?]/m,
                function() {
                    var e = '<input type="checkbox" disabled style="margin: 0px 0.35em 0.25em -1.6em; vertical-align: middle;"';
                    return u && (e += " checked"),
                    e += ">"
                })),
                d = d.replace(/^([-*+]|\d\.)[ \t]+[\S\n ]*/g,
                function(e) {
                    return "¨A" + e
                }),
                n || d.search(/\n{2,}/) > -1 ? (d = a.subParser("githubCodeBlocks")(d, r, t), d = a.subParser("blockGamut")(d, r, t)) : (d = (d = a.subParser("lists")(d, r, t)).replace(/\n$/, ""), d = (d = a.subParser("hashHTMLBlocks")(d, r, t)).replace(/\n\n+/g, "\n\n"), d = o ? a.subParser("paragraphs")(d, r, t) : a.subParser("spanGamut")(d, r, t)),
                d = d.replace("¨A", ""),
                d = "<li" + p + ">" + d + "</li>\n"
            }),
            e = e.replace(/¨0/g, ""),
            t.gListLevel--,
            n && (e = e.replace(/\s+$/, "")),
            e
        }
        function s(e, r) {
            if ("ol" === r) {
                var t = e.match(/^ *(\d+)\./);
                if (t && "1" !== t[1]) return ' start="' + t[1] + '"'
            }
            return ""
        }
        function o(e, t, a) {
            var o = r.disableForced4SpacesIndentedSublists ? /^ ?\d+\.[ \t]/gm: /^ {0,3}\d+\.[ \t]/gm,
            i = r.disableForced4SpacesIndentedSublists ? /^ ?[*+-][ \t]/gm: /^ {0,3}[*+-][ \t]/gm,
            l = "ul" === t ? o: i,
            c = "";
            if ( - 1 !== e.search(l)) !
            function r(u) {
                var d = u.search(l),
                p = s(e, t); - 1 !== d ? (c += "\n\n<" + t + p + ">\n" + n(u.slice(0, d), !!a) + "</" + t + ">\n", l = "ul" === (t = "ul" === t ? "ol": "ul") ? o: i, r(u.slice(d))) : c += "\n\n<" + t + p + ">\n" + n(u, !!a) + "</" + t + ">\n"
            } (e);
            else {
                var u = s(e, t);
                c = "\n\n<" + t + u + ">\n" + n(e, !!a) + "</" + t + ">\n"
            }
            return c
        }
        return e = t.converter._dispatch("lists.before", e, r, t),
        e += "¨0",
        e = t.gListLevel ? e.replace(/^(( {0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(¨0|\n{2,}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/gm,
        function(e, r, t) {
            return o(r, t.search(/[*+-]/g) > -1 ? "ul": "ol", !0)
        }) : e.replace(/(\n\n|^\n?)(( {0,3}([*+-]|\d+[.])[ \t]+)[^\r]+?(¨0|\n{2,}(?=\S)(?![ \t]*(?:[*+-]|\d+[.])[ \t]+)))/gm,
        function(e, r, t, a) {
            return o(t, a.search(/[*+-]/g) > -1 ? "ul": "ol", !1)
        }),
        e = e.replace(/¨0/, ""),
        e = t.converter._dispatch("lists.after", e, r, t)
    }), a.subParser("metadata",
    function(e, r, t) {
        "use strict";
        function a(e) {
            t.metadata.raw = e,
            (e = (e = e.replace(/&/g, "&amp;").replace(/"/g, "&quot;")).replace(/\n {4}/g, " ")).replace(/^([\S ]+): +([\s\S]+?)$/gm,
            function(e, r, a) {
                return t.metadata.parsed[r] = a,
                ""
            })
        }
        return r.metadata ? (e = t.converter._dispatch("metadata.before", e, r, t), e = e.replace(/^\s*«««+(\S*?)\n([\s\S]+?)\n»»»+\n/,
        function(e, r, t) {
            return a(t),
            "¨M"
        }), e = e.replace(/^\s*---+(\S*?)\n([\s\S]+?)\n---+\n/,
        function(e, r, n) {
            return r && (t.metadata.format = r),
            a(n),
            "¨M"
        }), e = e.replace(/¨M/g, ""), e = t.converter._dispatch("metadata.after", e, r, t)) : e
    }), a.subParser("outdent",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("outdent.before", e, r, t),
        e = e.replace(/^(\t|[ ]{1,4})/gm, "¨0"),
        e = e.replace(/¨0/g, ""),
        e = t.converter._dispatch("outdent.after", e, r, t)
    }), a.subParser("paragraphs",
    function(e, r, t) {
        "use strict";
        for (var n = (e = (e = (e = t.converter._dispatch("paragraphs.before", e, r, t)).replace(/^\n+/g, "")).replace(/\n+$/g, "")).split(/\n{2,}/g), s = [], o = n.length, i = 0; i < o; i++) {
            var l = n[i];
            l.search(/¨(K|G)(\d+)\1/g) >= 0 ? s.push(l) : l.search(/\S/) >= 0 && (l = (l = a.subParser("spanGamut")(l, r, t)).replace(/^([ \t]*)/g, "<p>"), l += "</p>", s.push(l))
        }
        for (o = s.length, i = 0; i < o; i++) {
            for (var c = "",
            u = s[i], d = !1;
            /¨(K|G)(\d+)\1/.test(u);) {
                var p = RegExp.$1,
                h = RegExp.$2;
                c = (c = "K" === p ? t.gHtmlBlocks[h] : d ? a.subParser("encodeCode")(t.ghCodeBlocks[h].text, r, t) : t.ghCodeBlocks[h].codeblock).replace(/\$/g, "$$$$"),
                u = u.replace(/(\n\n)?¨(K|G)\d+\2(\n\n)?/, c),
                /^<pre\b[^>]*>\s*<code\b[^>]*>/.test(u) && (d = !0)
            }
            s[i] = u
        }
        return e = s.join("\n"),
        e = e.replace(/^\n+/g, ""),
        e = e.replace(/\n+$/g, ""),
        t.converter._dispatch("paragraphs.after", e, r, t)
    }), a.subParser("runExtension",
    function(e, r, t, a) {
        "use strict";
        if (e.filter) r = e.filter(r, a.converter, t);
        else if (e.regex) {
            var n = e.regex;
            n instanceof RegExp || (n = new RegExp(n, "g")),
            r = r.replace(n, e.replace)
        }
        return r
    }), a.subParser("spanGamut",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("spanGamut.before", e, r, t),
        e = a.subParser("codeSpans")(e, r, t),
        e = a.subParser("escapeSpecialCharsWithinTagAttributes")(e, r, t),
        e = a.subParser("encodeBackslashEscapes")(e, r, t),
        e = a.subParser("images")(e, r, t),
        e = a.subParser("anchors")(e, r, t),
        e = a.subParser("autoLinks")(e, r, t),
        e = a.subParser("simplifiedAutoLinks")(e, r, t),
        e = a.subParser("emoji")(e, r, t),
        e = a.subParser("underline")(e, r, t),
        e = a.subParser("italicsAndBold")(e, r, t),
        e = a.subParser("strikethrough")(e, r, t),
        e = a.subParser("ellipsis")(e, r, t),
        e = a.subParser("hashHTMLSpans")(e, r, t),
        e = a.subParser("encodeAmpsAndAngles")(e, r, t),
        r.simpleLineBreaks ? /\n\n¨K/.test(e) || (e = e.replace(/\n+/g, "<br />\n")) : e = e.replace(/  +\n/g, "<br />\n"),
        e = t.converter._dispatch("spanGamut.after", e, r, t)
    }), a.subParser("strikethrough",
    function(e, r, t) {
        "use strict";
        return r.strikethrough && (e = (e = t.converter._dispatch("strikethrough.before", e, r, t)).replace(/(?:~){2}([\s\S]+?)(?:~){2}/g,
        function(e, n) {
            return function(e) {
                return r.simplifiedAutoLink && (e = a.subParser("simplifiedAutoLinks")(e, r, t)),
                "<del>" + e + "</del>"
            } (n)
        }), e = t.converter._dispatch("strikethrough.after", e, r, t)),
        e
    }), a.subParser("stripLinkDefinitions",
    function(e, r, t) {
        "use strict";
        var n = function(e, n, s, o, i, l, c) {
            return n = n.toLowerCase(),
            s.match(/^data:.+?\/.+?;base64,/) ? t.gUrls[n] = s.replace(/\s/g, "") : t.gUrls[n] = a.subParser("encodeAmpsAndAngles")(s, r, t),
            l ? l + c: (c && (t.gTitles[n] = c.replace(/"|'/g, "&quot;")), r.parseImgDimensions && o && i && (t.gDimensions[n] = {
                width: o,
                height: i
            }), "")
        };
        return e = (e += "¨0").replace(/^ {0,3}\[(.+)]:[ \t]*\n?[ \t]*<?(data:.+?\/.+?;base64,[A-Za-z0-9+/ = \n] + ?) > ?( ? :=([ * \d] + [A - Za - z % ] {
            0,
            4
        }) x([ * \d] + [A - Za - z % ] {
            0,
            4
        })) ? [\t] * \n ? [\t] * ( ? :(\n * )["|'(](.+?)[" | ')][ \t]*)?(?:\n\n|(?=¨0)|(?=\n\[))/gm,n),e=e.replace(/^ {0,3}\[(.+)]:[ \t]*\n?[ \t]*<?([^>\s]+)>?(?: =([*\d]+[A-Za-z%]{0,4})x([*\d]+[A-Za-z%]{0,4}))?[ \t]*\n?[ \t]*(?:(\n*)["|' (](. + ?)["|')][ \t]*)?(?:\n+|(?=¨0))/gm,n),e=e.replace(/¨0/,"")}),a.subParser("tables ",function(e,r,t){"use strict ";function n(e){return/^:[ \t]*--*$/.test(e)?' style="text - align: left;
        "':/^--*[ \t]*:[ \t]*$/.test(e)?' style="text - align: right;
        "':/^:[ \t]*--*[ \t]*:$/.test(e)?' style="text - align: center;
        "':""}function s(e,n){var s="";return e=e.trim(),(r.tablesHeaderId||r.tableHeaderId)&&(s=' id="'+e.replace(/ /g,"_").toLowerCase()+'"'),e=a.subParser("spanGamut ")(e,r,t)," < th "+s+n+" > "+e+" < /th>\n"}function o(e,n){return"<td"+n+">"+a.subParser("spanGamut")(e,r,t)+"</td > \n "}function i(e){var i,l=e.split("\n ");for(i=0;i<l.length;++i)/^ {0,3}\|/.test(l[i])&&(l[i]=l[i].replace(/^ {0,3}\|/,"")),/\|[ \t]*$/.test(l[i])&&(l[i]=l[i].replace(/\|[ \t]*$/,"")),l[i]=a.subParser("codeSpans ")(l[i],r,t);var c=l[0].split(" | ").map(function(e){return e.trim()}),u=l[1].split(" | ").map(function(e){return e.trim()}),d=[],p=[],h=[],_=[];for(l.shift(),l.shift(),i=0;i<l.length;++i)""!==l[i].trim()&&d.push(l[i].split(" | ").map(function(e){return e.trim()}));if(c.length<u.length)return e;for(i=0;i<u.length;++i)h.push(n(u[i]));for(i=0;i<c.length;++i)a.helper.isUndefined(h[i])&&(h[i]=""),p.push(s(c[i],h[i]));for(i=0;i<d.length;++i){for(var g=[],m=0;m<p.length;++m)a.helper.isUndefined(d[i][m]),g.push(o(d[i][m],h[m]));_.push(g)}return function(e,r){for(var t=" < table > \n < thead > \n < tr > \n ",a=e.length,n=0;n<a;++n)t+=e[n];for(t+=" < /tr>\n</thead > \n < tbody > \n ",n=0;n<r.length;++n){t+=" < tr > \n ";for(var s=0;s<a;++s)t+=r[n][s];t+=" < /tr>\n"}return t+="</tbody > \n < /table>\n"}(p,_)}if(!r.tables)return e;return e=t.converter._dispatch("tables.before",e,r,t),e=e.replace(/\\ (\ | ) / g, a.helper.escapeCharactersCallback), e = e.replace(/^ {0,3}\|?.+\|.+\n {0,3}\|?[ \t]*:?[ \t]*(?:[-=]){2,}[ \t]*:?[ \t]*\|[ \t]*:?[ \t]*(?:[-=]){2,}[\s\S]+?(?:\n\n|¨0)/gm, i), e = e.replace(/^ {0,3}\|.+\|[ \t]*\n {0,3}\|[ \t]*:?[ \t]*(?:[-=]){2,}[ \t]*:?[ \t]*\|[ \t]*\n( {0,3}\|.+\|[ \t]*\n)*(?:\n|¨0)/gm, i), e = t.converter._dispatch("tables.after", e, r, t)
    }), a.subParser("underline",
    function(e, r, t) {
        "use strict";
        return r.underline ? (e = t.converter._dispatch("underline.before", e, r, t), e = r.literalMidWordUnderscores ? (e = e.replace(/\b___(\S[\s\S]*?)___\b/g,
        function(e, r) {
            return "<u>" + r + "</u>"
        })).replace(/\b__(\S[\s\S]*?)__\b/g,
        function(e, r) {
            return "<u>" + r + "</u>"
        }) : (e = e.replace(/___(\S[\s\S]*?)___/g,
        function(e, r) {
            return /\S$/.test(r) ? "<u>" + r + "</u>": e
        })).replace(/__(\S[\s\S]*?)__/g,
        function(e, r) {
            return /\S$/.test(r) ? "<u>" + r + "</u>": e
        }), e = e.replace(/(_)/g, a.helper.escapeCharactersCallback), e = t.converter._dispatch("underline.after", e, r, t)) : e
    }), a.subParser("unescapeSpecialChars",
    function(e, r, t) {
        "use strict";
        return e = t.converter._dispatch("unescapeSpecialChars.before", e, r, t),
        e = e.replace(/¨E(\d+)E/g,
        function(e, r) {
            var t = parseInt(r);
            return String.fromCharCode(t)
        }),
        e = t.converter._dispatch("unescapeSpecialChars.after", e, r, t)
    }), a.subParser("makeMarkdown.blockquote",
    function(e, r) {
        "use strict";
        var t = "";
        if (e.hasChildNodes()) for (var n = e.childNodes,
        s = n.length,
        o = 0; o < s; ++o) {
            var i = a.subParser("makeMarkdown.node")(n[o], r);
            "" !== i && (t += i)
        }
        return t = t.trim(),
        t = "> " + t.split("\n").join("\n> ")
    }), a.subParser("makeMarkdown.codeBlock",
    function(e, r) {
        "use strict";
        var t = e.getAttribute("language"),
        a = e.getAttribute("precodenum");
        return "```" + t + "\n" + r.preList[a] + "\n```"
    }), a.subParser("makeMarkdown.codeSpan",
    function(e) {
        "use strict";
        return "`" + e.innerHTML + "`"
    }), a.subParser("makeMarkdown.emphasis",
    function(e, r) {
        "use strict";
        var t = "";
        if (e.hasChildNodes()) {
            t += "*";
            for (var n = e.childNodes,
            s = n.length,
            o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r);
            t += "*"
        }
        return t
    }), a.subParser("makeMarkdown.header",
    function(e, r, t) {
        "use strict";
        var n = new Array(t + 1).join("#"),
        s = "";
        if (e.hasChildNodes()) {
            s = n + " ";
            for (var o = e.childNodes,
            i = o.length,
            l = 0; l < i; ++l) s += a.subParser("makeMarkdown.node")(o[l], r)
        }
        return s
    }), a.subParser("makeMarkdown.hr",
    function() {
        "use strict";
        return "---"
    }), a.subParser("makeMarkdown.image",
    function(e) {
        "use strict";
        var r = "";
        return e.hasAttribute("src") && (r += "![" + e.getAttribute("alt") + "](", r += "<" + e.getAttribute("src") + ">", e.hasAttribute("width") && e.hasAttribute("height") && (r += " =" + e.getAttribute("width") + "x" + e.getAttribute("height")), e.hasAttribute("title") && (r += ' "' + e.getAttribute("title") + '"'), r += ")"),
        r
    }), a.subParser("makeMarkdown.links",
    function(e, r) {
        "use strict";
        var t = "";
        if (e.hasChildNodes() && e.hasAttribute("href")) {
            var n = e.childNodes,
            s = n.length;
            t = "[";
            for (var o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r);
            t += "](",
            t += "<" + e.getAttribute("href") + ">",
            e.hasAttribute("title") && (t += ' "' + e.getAttribute("title") + '"'),
            t += ")"
        }
        return t
    }), a.subParser("makeMarkdown.list",
    function(e, r, t) {
        "use strict";
        var n = "";
        if (!e.hasChildNodes()) return "";
        for (var s = e.childNodes,
        o = s.length,
        i = e.getAttribute("start") || 1, l = 0; l < o; ++l) if (void 0 !== s[l].tagName && "li" === s[l].tagName.toLowerCase()) {
            n += ("ol" === t ? i.toString() + ". ": "- ") + a.subParser("makeMarkdown.listItem")(s[l], r),
            ++i
        }
        return (n += "\n\x3c!-- --\x3e\n").trim()
    }), a.subParser("makeMarkdown.listItem",
    function(e, r) {
        "use strict";
        for (var t = "",
        n = e.childNodes,
        s = n.length,
        o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r);
        return /\n$/.test(t) ? t = t.split("\n").join("\n    ").replace(/^ {4}$/gm, "").replace(/\n\n+/g, "\n\n") : t += "\n",
        t
    }), a.subParser("makeMarkdown.node",
    function(e, r, t) {
        "use strict";
        t = t || !1;
        var n = "";
        if (3 === e.nodeType) return a.subParser("makeMarkdown.txt")(e, r);
        if (8 === e.nodeType) return "\x3c!--" + e.data + "--\x3e\n\n";
        if (1 !== e.nodeType) return "";
        switch (e.tagName.toLowerCase()) {
        case "h1":
            t || (n = a.subParser("makeMarkdown.header")(e, r, 1) + "\n\n");
            break;
        case "h2":
            t || (n = a.subParser("makeMarkdown.header")(e, r, 2) + "\n\n");
            break;
        case "h3":
            t || (n = a.subParser("makeMarkdown.header")(e, r, 3) + "\n\n");
            break;
        case "h4":
            t || (n = a.subParser("makeMarkdown.header")(e, r, 4) + "\n\n");
            break;
        case "h5":
            t || (n = a.subParser("makeMarkdown.header")(e, r, 5) + "\n\n");
            break;
        case "h6":
            t || (n = a.subParser("makeMarkdown.header")(e, r, 6) + "\n\n");
            break;
        case "p":
            t || (n = a.subParser("makeMarkdown.paragraph")(e, r) + "\n\n");
            break;
        case "blockquote":
            t || (n = a.subParser("makeMarkdown.blockquote")(e, r) + "\n\n");
            break;
        case "hr":
            t || (n = a.subParser("makeMarkdown.hr")(e, r) + "\n\n");
            break;
        case "ol":
            t || (n = a.subParser("makeMarkdown.list")(e, r, "ol") + "\n\n");
            break;
        case "ul":
            t || (n = a.subParser("makeMarkdown.list")(e, r, "ul") + "\n\n");
            break;
        case "precode":
            t || (n = a.subParser("makeMarkdown.codeBlock")(e, r) + "\n\n");
            break;
        case "pre":
            t || (n = a.subParser("makeMarkdown.pre")(e, r) + "\n\n");
            break;
        case "table":
            t || (n = a.subParser("makeMarkdown.table")(e, r) + "\n\n");
            break;
        case "code":
            n = a.subParser("makeMarkdown.codeSpan")(e, r);
            break;
        case "em":
        case "i":
            n = a.subParser("makeMarkdown.emphasis")(e, r);
            break;
        case "strong":
        case "b":
            n = a.subParser("makeMarkdown.strong")(e, r);
            break;
        case "del":
            n = a.subParser("makeMarkdown.strikethrough")(e, r);
            break;
        case "a":
            n = a.subParser("makeMarkdown.links")(e, r);
            break;
        case "img":
            n = a.subParser("makeMarkdown.image")(e, r);
            break;
        default:
            n = e.outerHTML + "\n\n"
        }
        return n
    }), a.subParser("makeMarkdown.paragraph",
    function(e, r) {
        "use strict";
        var t = "";
        if (e.hasChildNodes()) for (var n = e.childNodes,
        s = n.length,
        o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r);
        return t = t.trim()
    }), a.subParser("makeMarkdown.pre",
    function(e, r) {
        "use strict";
        var t = e.getAttribute("prenum");
        return "<pre>" + r.preList[t] + "</pre>"
    }), a.subParser("makeMarkdown.strikethrough",
    function(e, r) {
        "use strict";
        var t = "";
        if (e.hasChildNodes()) {
            t += "~~";
            for (var n = e.childNodes,
            s = n.length,
            o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r);
            t += "~~"
        }
        return t
    }), a.subParser("makeMarkdown.strong",
    function(e, r) {
        "use strict";
        var t = "";
        if (e.hasChildNodes()) {
            t += "**";
            for (var n = e.childNodes,
            s = n.length,
            o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r);
            t += "**"
        }
        return t
    }), a.subParser("makeMarkdown.table",
    function(e, r) {
        "use strict";
        var t, n, s = "",
        o = [[], []],
        i = e.querySelectorAll("thead>tr>th"),
        l = e.querySelectorAll("tbody>tr");
        for (t = 0; t < i.length; ++t) {
            var c = a.subParser("makeMarkdown.tableCell")(i[t], r),
            u = "---";
            if (i[t].hasAttribute("style")) {
                switch (i[t].getAttribute("style").toLowerCase().replace(/\s/g, "")) {
                case "text-align:left;":
                    u = ":---";
                    break;
                case "text-align:right;":
                    u = "---:";
                    break;
                case "text-align:center;":
                    u = ":---:"
                }
            }
            o[0][t] = c.trim(),
            o[1][t] = u
        }
        for (t = 0; t < l.length; ++t) {
            var d = o.push([]) - 1,
            p = l[t].getElementsByTagName("td");
            for (n = 0; n < i.length; ++n) {
                var h = " ";
                void 0 !== p[n] && (h = a.subParser("makeMarkdown.tableCell")(p[n], r)),
                o[d].push(h)
            }
        }
        var _ = 3;
        for (t = 0; t < o.length; ++t) for (n = 0; n < o[t].length; ++n) {
            var g = o[t][n].length;
            g > _ && (_ = g)
        }
        for (t = 0; t < o.length; ++t) {
            for (n = 0; n < o[t].length; ++n) 1 === t ? ":" === o[t][n].slice( - 1) ? o[t][n] = a.helper.padEnd(o[t][n].slice( - 1), _ - 1, "-") + ":": o[t][n] = a.helper.padEnd(o[t][n], _, "-") : o[t][n] = a.helper.padEnd(o[t][n], _);
            s += "| " + o[t].join(" | ") + " |\n"
        }
        return s.trim()
    }), a.subParser("makeMarkdown.tableCell",
    function(e, r) {
        "use strict";
        var t = "";
        if (!e.hasChildNodes()) return "";
        for (var n = e.childNodes,
        s = n.length,
        o = 0; o < s; ++o) t += a.subParser("makeMarkdown.node")(n[o], r, !0);
        return t.trim()
    }), a.subParser("makeMarkdown.txt",
    function(e) {
        "use strict";
        var r = e.nodeValue;
        return r = r.replace(/ +/g, " "),
        r = r.replace(/¨NBSP;/g, " "),
        r = a.helper.unescapeHTMLEntities(r),
        r = r.replace(/([*_~|`])/g, "\\$1"),
        r = r.replace(/^(\s*)>/g, "\\$1>"),
        r = r.replace(/^#/gm, "\\#"),
        r = r.replace(/^(\s*)([-=]{3,})(\s*)$/, "$1\\$2$3"),
        r = r.replace(/^( {0,3}\d+)\./gm, "$1\\."),
        r = r.replace(/^( {0,3})([+-])/gm, "$1\\$2"),
        r = r.replace(/]([\s]*)\(/g, "\\]$1\\("),
        r = r.replace(/^ {0,3}\[([\S \t]*?)]:/gm, "\\[$1]:")
    });
    "function" == typeof define && define.amd ? define(function() {
        "use strict";
        return a
    }) : "undefined" != typeof module && module.exports ? module.exports = a: this.showdown = a
}).call(this);
