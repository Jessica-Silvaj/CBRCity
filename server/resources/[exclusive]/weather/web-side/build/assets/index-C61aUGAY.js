(function () {
  if (window.__weatherPatchedFinal) return;
  window.__weatherPatchedFinal = true;
  const style = document.createElement("style");
  style.innerHTML =
    "input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button { -webkit-appearance: none; margin: 0; } input[type=number] { -moz-appearance: textfield; } .buttons { margin-bottom: 10px !important; }";
  document.head.appendChild(style);
  window.addEventListener("message", (e) => {
    if (e.data.action === "setTime" && e.data.data) {
      const timeStr =
        String(e.data.data.hour).padStart(2, "0") +
        ":" +
        String(e.data.data.minute).padStart(2, "0");
      window.gameTime = timeStr;
      const hourDiv = document.querySelector(".hour");
      if (hourDiv && hourDiv.firstChild && hourDiv.firstChild.nodeType === 3) {
        hourDiv.firstChild.nodeValue = timeStr;
      }
    }
  });
  const observer = new MutationObserver((mutations) => {
    const originalButtonsContainer = document.querySelector(
      ".buttons:not(#custom-buttons-container)",
    );
    if (
      originalButtonsContainer &&
      !document.getElementById("custom-buttons-container")
    ) {
      const customContainer = document.createElement("div");
      customContainer.id = "custom-buttons-container";
      customContainer.className = "buttons";
      customContainer.style.marginBottom = "10px";
      const inputItem = document.createElement("div");
      inputItem.className = "reset";
      inputItem.style.cursor = "default";
      inputItem.style.display = "flex";
      inputItem.style.justifyContent = "center";
      inputItem.style.gap = "5px";
      inputItem.innerHTML =
        '<input type="number" id="time-hour" placeholder="HH" min="0" max="23" style="width:40px; background:rgba(0,0,0,0.3); border:1px solid rgba(255,255,255,0.1); border-radius:3px; color:white; font-family:inherit; font-size:inherit; text-align:center; outline:none;"><span style="color:white; font-weight:bold; align-self:center;">:</span><input type="number" id="time-minute" placeholder="MM" min="0" max="59" style="width:40px; background:rgba(0,0,0,0.3); border:1px solid rgba(255,255,255,0.1); border-radius:3px; color:white; font-family:inherit; font-size:inherit; text-align:center; outline:none;">';
      const applyItem = document.createElement("div");
      applyItem.className = "reset";
      applyItem.style.display = "flex";
      applyItem.style.justifyContent = "center";
      applyItem.innerHTML = "<span>Aplicar Horário</span>";
      customContainer.appendChild(inputItem);
      customContainer.appendChild(applyItem);
      originalButtonsContainer.parentNode.insertBefore(
        customContainer,
        originalButtonsContainer,
      );
      let p = originalButtonsContainer.parentNode;
      while (p && p.id !== "root") {
        p.style.setProperty("height", "auto", "important");
        p.style.setProperty("min-height", "fit-content", "important");
        p = p.parentNode;
      }
      applyItem.addEventListener("click", () => {
        const h = parseInt(document.getElementById("time-hour").value);
        const m = parseInt(document.getElementById("time-minute").value);
        if (!isNaN(h) && !isNaN(m)) {
          fetch("https://weather/applyWeatherAndTime", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ hour: h, minute: m }),
          });
          document.getElementById("time-hour").value = "";
          document.getElementById("time-minute").value = "";
        }
      });
    }
  });
  observer.observe(document.body, { childList: true, subtree: true });
})();
window.addEventListener("message", (e) => {
  if (e.data.action === "setTime" && e.data.data) {
    const timeStr =
      String(e.data.data.hour).padStart(2, "0") +
      ":" +
      String(e.data.data.minute).padStart(2, "0");
    window.gameTime = timeStr;
    const hourDiv = document.querySelector(".hour");
    if (hourDiv && hourDiv.firstChild && hourDiv.firstChild.nodeType === 3) {
      hourDiv.firstChild.nodeValue = timeStr;
    }
  }
});
(function () {
  const e = document.createElement("link").relList;
  if (e && e.supports && e.supports("modulepreload")) return;
  for (const l of document.querySelectorAll('link[rel="modulepreload"]')) o(l);
  new MutationObserver((l) => {
    for (const u of l)
      if (u.type === "childList")
        for (const c of u.addedNodes)
          c.tagName === "LINK" && c.rel === "modulepreload" && o(c);
  }).observe(document, { childList: !0, subtree: !0 });
  function r(l) {
    const u = {};
    return (
      l.integrity && (u.integrity = l.integrity),
      l.referrerPolicy && (u.referrerPolicy = l.referrerPolicy),
      l.crossOrigin === "use-credentials"
        ? (u.credentials = "include")
        : l.crossOrigin === "anonymous"
          ? (u.credentials = "omit")
          : (u.credentials = "same-origin"),
      u
    );
  }
  function o(l) {
    if (l.ep) return;
    l.ep = !0;
    const u = r(l);
    fetch(l.href, u);
  }
})();
function p0(n) {
  return n && n.__esModule && Object.prototype.hasOwnProperty.call(n, "default")
    ? n.default
    : n;
}
var nc = { exports: {} },
  Lo = {},
  ic = { exports: {} },
  fe = {};
/**
 * @license React
 * react.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */ var gd;
function W4() {
  if (gd) return fe;
  gd = 1;
  var n = Symbol.for("react.element"),
    e = Symbol.for("react.portal"),
    r = Symbol.for("react.fragment"),
    o = Symbol.for("react.strict_mode"),
    l = Symbol.for("react.profiler"),
    u = Symbol.for("react.provider"),
    c = Symbol.for("react.context"),
    d = Symbol.for("react.forward_ref"),
    p = Symbol.for("react.suspense"),
    m = Symbol.for("react.memo"),
    g = Symbol.for("react.lazy"),
    v = Symbol.iterator;
  function C(P) {
    return P === null || typeof P != "object"
      ? null
      : ((P = (v && P[v]) || P["@@iterator"]),
        typeof P == "function" ? P : null);
  }
  var x = {
      isMounted: function () {
        return !1;
      },
      enqueueForceUpdate: function () {},
      enqueueReplaceState: function () {},
      enqueueSetState: function () {},
    },
    b = Object.assign,
    _ = {};
  function E(P, L, le) {
    ((this.props = P),
      (this.context = L),
      (this.refs = _),
      (this.updater = le || x));
  }
  ((E.prototype.isReactComponent = {}),
    (E.prototype.setState = function (P, L) {
      if (typeof P != "object" && typeof P != "function" && P != null)
        throw Error(
          "setState(...): takes an object of state variables to update or a function which returns an object of state variables.",
        );
      this.updater.enqueueSetState(this, P, L, "setState");
    }),
    (E.prototype.forceUpdate = function (P) {
      this.updater.enqueueForceUpdate(this, P, "forceUpdate");
    }));
  function T() {}
  T.prototype = E.prototype;
  function D(P, L, le) {
    ((this.props = P),
      (this.context = L),
      (this.refs = _),
      (this.updater = le || x));
  }
  var I = (D.prototype = new T());
  ((I.constructor = D), b(I, E.prototype), (I.isPureReactComponent = !0));
  var R = Array.isArray,
    N = Object.prototype.hasOwnProperty,
    F = { current: null },
    V = { key: !0, ref: !0, __self: !0, __source: !0 };
  function ie(P, L, le) {
    var ae,
      de = {},
      ce = null,
      xe = null;
    if (L != null)
      for (ae in (L.ref !== void 0 && (xe = L.ref),
      L.key !== void 0 && (ce = "" + L.key),
      L))
        N.call(L, ae) && !V.hasOwnProperty(ae) && (de[ae] = L[ae]);
    var ye = arguments.length - 2;
    if (ye === 1) de.children = le;
    else if (1 < ye) {
      for (var Ce = Array(ye), it = 0; it < ye; it++)
        Ce[it] = arguments[it + 2];
      de.children = Ce;
    }
    if (P && P.defaultProps)
      for (ae in ((ye = P.defaultProps), ye))
        de[ae] === void 0 && (de[ae] = ye[ae]);
    return {
      $$typeof: n,
      type: P,
      key: ce,
      ref: xe,
      props: de,
      _owner: F.current,
    };
  }
  function he(P, L) {
    return {
      $$typeof: n,
      type: P.type,
      key: L,
      ref: P.ref,
      props: P.props,
      _owner: P._owner,
    };
  }
  function _e(P) {
    return typeof P == "object" && P !== null && P.$$typeof === n;
  }
  function Se(P) {
    var L = { "=": "=0", ":": "=2" };
    return (
      "$" +
      P.replace(/[=:]/g, function (le) {
        return L[le];
      })
    );
  }
  var We = /\/+/g;
  function Be(P, L) {
    return typeof P == "object" && P !== null && P.key != null
      ? Se("" + P.key)
      : L.toString(36);
  }
  function pe(P, L, le, ae, de) {
    var ce = typeof P;
    (ce === "undefined" || ce === "boolean") && (P = null);
    var xe = !1;
    if (P === null) xe = !0;
    else
      switch (ce) {
        case "string":
        case "number":
          xe = !0;
          break;
        case "object":
          switch (P.$$typeof) {
            case n:
            case e:
              xe = !0;
          }
      }
    if (xe)
      return (
        (xe = P),
        (de = de(xe)),
        (P = ae === "" ? "." + Be(xe, 0) : ae),
        R(de)
          ? ((le = ""),
            P != null && (le = P.replace(We, "$&/") + "/"),
            pe(de, L, le, "", function (it) {
              return it;
            }))
          : de != null &&
            (_e(de) &&
              (de = he(
                de,
                le +
                  (!de.key || (xe && xe.key === de.key)
                    ? ""
                    : ("" + de.key).replace(We, "$&/") + "/") +
                  P,
              )),
            L.push(de)),
        1
      );
    if (((xe = 0), (ae = ae === "" ? "." : ae + ":"), R(P)))
      for (var ye = 0; ye < P.length; ye++) {
        ce = P[ye];
        var Ce = ae + Be(ce, ye);
        xe += pe(ce, L, le, Ce, de);
      }
    else if (((Ce = C(P)), typeof Ce == "function"))
      for (P = Ce.call(P), ye = 0; !(ce = P.next()).done;)
        ((ce = ce.value),
          (Ce = ae + Be(ce, ye++)),
          (xe += pe(ce, L, le, Ce, de)));
    else if (ce === "object")
      throw (
        (L = String(P)),
        Error(
          "Objects are not valid as a React child (found: " +
            (L === "[object Object]"
              ? "object with keys {" + Object.keys(P).join(", ") + "}"
              : L) +
            "). If you meant to render a collection of children, use an array instead.",
        )
      );
    return xe;
  }
  function qe(P, L, le) {
    if (P == null) return P;
    var ae = [],
      de = 0;
    return (
      pe(P, ae, "", "", function (ce) {
        return L.call(le, ce, de++);
      }),
      ae
    );
  }
  function ft(P) {
    if (P._status === -1) {
      var L = P._result;
      ((L = L()),
        L.then(
          function (le) {
            (P._status === 0 || P._status === -1) &&
              ((P._status = 1), (P._result = le));
          },
          function (le) {
            (P._status === 0 || P._status === -1) &&
              ((P._status = 2), (P._result = le));
          },
        ),
        P._status === -1 && ((P._status = 0), (P._result = L)));
    }
    if (P._status === 1) return P._result.default;
    throw P._result;
  }
  var Ee = { current: null },
    W = { transition: null },
    X = {
      ReactCurrentDispatcher: Ee,
      ReactCurrentBatchConfig: W,
      ReactCurrentOwner: F,
    };
  function q() {
    throw Error("act(...) is not supported in production builds of React.");
  }
  return (
    (fe.Children = {
      map: qe,
      forEach: function (P, L, le) {
        qe(
          P,
          function () {
            L.apply(this, arguments);
          },
          le,
        );
      },
      count: function (P) {
        var L = 0;
        return (
          qe(P, function () {
            L++;
          }),
          L
        );
      },
      toArray: function (P) {
        return (
          qe(P, function (L) {
            return L;
          }) || []
        );
      },
      only: function (P) {
        if (!_e(P))
          throw Error(
            "React.Children.only expected to receive a single React element child.",
          );
        return P;
      },
    }),
    (fe.Component = E),
    (fe.Fragment = r),
    (fe.Profiler = l),
    (fe.PureComponent = D),
    (fe.StrictMode = o),
    (fe.Suspense = p),
    (fe.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = X),
    (fe.act = q),
    (fe.cloneElement = function (P, L, le) {
      if (P == null)
        throw Error(
          "React.cloneElement(...): The argument must be a React element, but you passed " +
            P +
            ".",
        );
      var ae = b({}, P.props),
        de = P.key,
        ce = P.ref,
        xe = P._owner;
      if (L != null) {
        if (
          (L.ref !== void 0 && ((ce = L.ref), (xe = F.current)),
          L.key !== void 0 && (de = "" + L.key),
          P.type && P.type.defaultProps)
        )
          var ye = P.type.defaultProps;
        for (Ce in L)
          N.call(L, Ce) &&
            !V.hasOwnProperty(Ce) &&
            (ae[Ce] = L[Ce] === void 0 && ye !== void 0 ? ye[Ce] : L[Ce]);
      }
      var Ce = arguments.length - 2;
      if (Ce === 1) ae.children = le;
      else if (1 < Ce) {
        ye = Array(Ce);
        for (var it = 0; it < Ce; it++) ye[it] = arguments[it + 2];
        ae.children = ye;
      }
      return {
        $$typeof: n,
        type: P.type,
        key: de,
        ref: ce,
        props: ae,
        _owner: xe,
      };
    }),
    (fe.createContext = function (P) {
      return (
        (P = {
          $$typeof: c,
          _currentValue: P,
          _currentValue2: P,
          _threadCount: 0,
          Provider: null,
          Consumer: null,
          _defaultValue: null,
          _globalName: null,
        }),
        (P.Provider = { $$typeof: u, _context: P }),
        (P.Consumer = P)
      );
    }),
    (fe.createElement = ie),
    (fe.createFactory = function (P) {
      var L = ie.bind(null, P);
      return ((L.type = P), L);
    }),
    (fe.createRef = function () {
      return { current: null };
    }),
    (fe.forwardRef = function (P) {
      return { $$typeof: d, render: P };
    }),
    (fe.isValidElement = _e),
    (fe.lazy = function (P) {
      return { $$typeof: g, _payload: { _status: -1, _result: P }, _init: ft };
    }),
    (fe.memo = function (P, L) {
      return { $$typeof: m, type: P, compare: L === void 0 ? null : L };
    }),
    (fe.startTransition = function (P) {
      var L = W.transition;
      W.transition = {};
      try {
        P();
      } finally {
        W.transition = L;
      }
    }),
    (fe.unstable_act = q),
    (fe.useCallback = function (P, L) {
      return Ee.current.useCallback(P, L);
    }),
    (fe.useContext = function (P) {
      return Ee.current.useContext(P);
    }),
    (fe.useDebugValue = function () {}),
    (fe.useDeferredValue = function (P) {
      return Ee.current.useDeferredValue(P);
    }),
    (fe.useEffect = function (P, L) {
      return Ee.current.useEffect(P, L);
    }),
    (fe.useId = function () {
      return Ee.current.useId();
    }),
    (fe.useImperativeHandle = function (P, L, le) {
      return Ee.current.useImperativeHandle(P, L, le);
    }),
    (fe.useInsertionEffect = function (P, L) {
      return Ee.current.useInsertionEffect(P, L);
    }),
    (fe.useLayoutEffect = function (P, L) {
      return Ee.current.useLayoutEffect(P, L);
    }),
    (fe.useMemo = function (P, L) {
      return Ee.current.useMemo(P, L);
    }),
    (fe.useReducer = function (P, L, le) {
      return Ee.current.useReducer(P, L, le);
    }),
    (fe.useRef = function (P) {
      return Ee.current.useRef(P);
    }),
    (fe.useState = function (P) {
      return Ee.current.useState(P);
    }),
    (fe.useSyncExternalStore = function (P, L, le) {
      return Ee.current.useSyncExternalStore(P, L, le);
    }),
    (fe.useTransition = function () {
      return Ee.current.useTransition();
    }),
    (fe.version = "18.3.1"),
    fe
  );
}
var vd;
function Zl() {
  return (vd || ((vd = 1), (ic.exports = W4())), ic.exports);
}
/**
 * @license React
 * react-jsx-runtime.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */ var Cd;
function q4() {
  if (Cd) return Lo;
  Cd = 1;
  var n = Zl(),
    e = Symbol.for("react.element"),
    r = Symbol.for("react.fragment"),
    o = Object.prototype.hasOwnProperty,
    l = n.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,
    u = { key: !0, ref: !0, __self: !0, __source: !0 };
  function c(d, p, m) {
    var g,
      v = {},
      C = null,
      x = null;
    (m !== void 0 && (C = "" + m),
      p.key !== void 0 && (C = "" + p.key),
      p.ref !== void 0 && (x = p.ref));
    for (g in p) o.call(p, g) && !u.hasOwnProperty(g) && (v[g] = p[g]);
    if (d && d.defaultProps)
      for (g in ((p = d.defaultProps), p)) v[g] === void 0 && (v[g] = p[g]);
    return {
      $$typeof: e,
      type: d,
      key: C,
      ref: x,
      props: v,
      _owner: l.current,
    };
  }
  return ((Lo.Fragment = r), (Lo.jsx = c), (Lo.jsxs = c), Lo);
}
var wd;
function G4() {
  return (wd || ((wd = 1), (nc.exports = q4())), nc.exports);
}
var J = G4(),
  ve = Zl();
const bn = p0(ve);
var ul = {},
  rc = { exports: {} },
  Mt = {},
  oc = { exports: {} },
  sc = {};
/**
 * @license React
 * scheduler.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */ var xd;
function Q4() {
  return (
    xd ||
      ((xd = 1),
      (function (n) {
        function e(W, X) {
          var q = W.length;
          W.push(X);
          e: for (; 0 < q;) {
            var P = (q - 1) >>> 1,
              L = W[P];
            if (0 < l(L, X)) ((W[P] = X), (W[q] = L), (q = P));
            else break e;
          }
        }
        function r(W) {
          return W.length === 0 ? null : W[0];
        }
        function o(W) {
          if (W.length === 0) return null;
          var X = W[0],
            q = W.pop();
          if (q !== X) {
            W[0] = q;
            e: for (var P = 0, L = W.length, le = L >>> 1; P < le;) {
              var ae = 2 * (P + 1) - 1,
                de = W[ae],
                ce = ae + 1,
                xe = W[ce];
              if (0 > l(de, q))
                ce < L && 0 > l(xe, de)
                  ? ((W[P] = xe), (W[ce] = q), (P = ce))
                  : ((W[P] = de), (W[ae] = q), (P = ae));
              else if (ce < L && 0 > l(xe, q))
                ((W[P] = xe), (W[ce] = q), (P = ce));
              else break e;
            }
          }
          return X;
        }
        function l(W, X) {
          var q = W.sortIndex - X.sortIndex;
          return q !== 0 ? q : W.id - X.id;
        }
        if (
          typeof performance == "object" &&
          typeof performance.now == "function"
        ) {
          var u = performance;
          n.unstable_now = function () {
            return u.now();
          };
        } else {
          var c = Date,
            d = c.now();
          n.unstable_now = function () {
            return c.now() - d;
          };
        }
        var p = [],
          m = [],
          g = 1,
          v = null,
          C = 3,
          x = !1,
          b = !1,
          _ = !1,
          E = typeof setTimeout == "function" ? setTimeout : null,
          T = typeof clearTimeout == "function" ? clearTimeout : null,
          D = typeof setImmediate < "u" ? setImmediate : null;
        typeof navigator < "u" &&
          navigator.scheduling !== void 0 &&
          navigator.scheduling.isInputPending !== void 0 &&
          navigator.scheduling.isInputPending.bind(navigator.scheduling);
        function I(W) {
          for (var X = r(m); X !== null;) {
            if (X.callback === null) o(m);
            else if (X.startTime <= W)
              (o(m), (X.sortIndex = X.expirationTime), e(p, X));
            else break;
            X = r(m);
          }
        }
        function R(W) {
          if (((_ = !1), I(W), !b))
            if (r(p) !== null) ((b = !0), ft(N));
            else {
              var X = r(m);
              X !== null && Ee(R, X.startTime - W);
            }
        }
        function N(W, X) {
          ((b = !1), _ && ((_ = !1), T(ie), (ie = -1)), (x = !0));
          var q = C;
          try {
            for (
              I(X), v = r(p);
              v !== null && (!(v.expirationTime > X) || (W && !Se()));
            ) {
              var P = v.callback;
              if (typeof P == "function") {
                ((v.callback = null), (C = v.priorityLevel));
                var L = P(v.expirationTime <= X);
                ((X = n.unstable_now()),
                  typeof L == "function"
                    ? (v.callback = L)
                    : v === r(p) && o(p),
                  I(X));
              } else o(p);
              v = r(p);
            }
            if (v !== null) var le = !0;
            else {
              var ae = r(m);
              (ae !== null && Ee(R, ae.startTime - X), (le = !1));
            }
            return le;
          } finally {
            ((v = null), (C = q), (x = !1));
          }
        }
        var F = !1,
          V = null,
          ie = -1,
          he = 5,
          _e = -1;
        function Se() {
          return !(n.unstable_now() - _e < he);
        }
        function We() {
          if (V !== null) {
            var W = n.unstable_now();
            _e = W;
            var X = !0;
            try {
              X = V(!0, W);
            } finally {
              X ? Be() : ((F = !1), (V = null));
            }
          } else F = !1;
        }
        var Be;
        if (typeof D == "function")
          Be = function () {
            D(We);
          };
        else if (typeof MessageChannel < "u") {
          var pe = new MessageChannel(),
            qe = pe.port2;
          ((pe.port1.onmessage = We),
            (Be = function () {
              qe.postMessage(null);
            }));
        } else
          Be = function () {
            E(We, 0);
          };
        function ft(W) {
          ((V = W), F || ((F = !0), Be()));
        }
        function Ee(W, X) {
          ie = E(function () {
            W(n.unstable_now());
          }, X);
        }
        ((n.unstable_IdlePriority = 5),
          (n.unstable_ImmediatePriority = 1),
          (n.unstable_LowPriority = 4),
          (n.unstable_NormalPriority = 3),
          (n.unstable_Profiling = null),
          (n.unstable_UserBlockingPriority = 2),
          (n.unstable_cancelCallback = function (W) {
            W.callback = null;
          }),
          (n.unstable_continueExecution = function () {
            b || x || ((b = !0), ft(N));
          }),
          (n.unstable_forceFrameRate = function (W) {
            0 > W || 125 < W
              ? console.error(
                  "forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported",
                )
              : (he = 0 < W ? Math.floor(1e3 / W) : 5);
          }),
          (n.unstable_getCurrentPriorityLevel = function () {
            return C;
          }),
          (n.unstable_getFirstCallbackNode = function () {
            return r(p);
          }),
          (n.unstable_next = function (W) {
            switch (C) {
              case 1:
              case 2:
              case 3:
                var X = 3;
                break;
              default:
                X = C;
            }
            var q = C;
            C = X;
            try {
              return W();
            } finally {
              C = q;
            }
          }),
          (n.unstable_pauseExecution = function () {}),
          (n.unstable_requestPaint = function () {}),
          (n.unstable_runWithPriority = function (W, X) {
            switch (W) {
              case 1:
              case 2:
              case 3:
              case 4:
              case 5:
                break;
              default:
                W = 3;
            }
            var q = C;
            C = W;
            try {
              return X();
            } finally {
              C = q;
            }
          }),
          (n.unstable_scheduleCallback = function (W, X, q) {
            var P = n.unstable_now();
            switch (
              (typeof q == "object" && q !== null
                ? ((q = q.delay),
                  (q = typeof q == "number" && 0 < q ? P + q : P))
                : (q = P),
              W)
            ) {
              case 1:
                var L = -1;
                break;
              case 2:
                L = 250;
                break;
              case 5:
                L = 1073741823;
                break;
              case 4:
                L = 1e4;
                break;
              default:
                L = 5e3;
            }
            return (
              (L = q + L),
              (W = {
                id: g++,
                callback: X,
                priorityLevel: W,
                startTime: q,
                expirationTime: L,
                sortIndex: -1,
              }),
              q > P
                ? ((W.sortIndex = q),
                  e(m, W),
                  r(p) === null &&
                    W === r(m) &&
                    (_ ? (T(ie), (ie = -1)) : (_ = !0), Ee(R, q - P)))
                : ((W.sortIndex = L), e(p, W), b || x || ((b = !0), ft(N))),
              W
            );
          }),
          (n.unstable_shouldYield = Se),
          (n.unstable_wrapCallback = function (W) {
            var X = C;
            return function () {
              var q = C;
              C = X;
              try {
                return W.apply(this, arguments);
              } finally {
                C = q;
              }
            };
          }));
      })(sc)),
    sc
  );
}
var _d;
function Z4() {
  return (_d || ((_d = 1), (oc.exports = Q4())), oc.exports);
}
/**
 * @license React
 * react-dom.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */ var bd;
function K4() {
  if (bd) return Mt;
  bd = 1;
  var n = Zl(),
    e = Z4();
  function r(t) {
    for (
      var i = "https://reactjs.org/docs/error-decoder.html?invariant=" + t,
        s = 1;
      s < arguments.length;
      s++
    )
      i += "&args[]=" + encodeURIComponent(arguments[s]);
    return (
      "Minified React error #" +
      t +
      "; visit " +
      i +
      " for the full message or use the non-minified dev environment for full errors and additional helpful warnings."
    );
  }
  var o = new Set(),
    l = {};
  function u(t, i) {
    (c(t, i), c(t + "Capture", i));
  }
  function c(t, i) {
    for (l[t] = i, t = 0; t < i.length; t++) o.add(i[t]);
  }
  var d = !(
      typeof window > "u" ||
      typeof window.document > "u" ||
      typeof window.document.createElement > "u"
    ),
    p = Object.prototype.hasOwnProperty,
    m =
      /^[:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD][:A-Z_a-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD\-.0-9\u00B7\u0300-\u036F\u203F-\u2040]*$/,
    g = {},
    v = {};
  function C(t) {
    return p.call(v, t)
      ? !0
      : p.call(g, t)
        ? !1
        : m.test(t)
          ? (v[t] = !0)
          : ((g[t] = !0), !1);
  }
  function x(t, i, s, a) {
    if (s !== null && s.type === 0) return !1;
    switch (typeof i) {
      case "function":
      case "symbol":
        return !0;
      case "boolean":
        return a
          ? !1
          : s !== null
            ? !s.acceptsBooleans
            : ((t = t.toLowerCase().slice(0, 5)),
              t !== "data-" && t !== "aria-");
      default:
        return !1;
    }
  }
  function b(t, i, s, a) {
    if (i === null || typeof i > "u" || x(t, i, s, a)) return !0;
    if (a) return !1;
    if (s !== null)
      switch (s.type) {
        case 3:
          return !i;
        case 4:
          return i === !1;
        case 5:
          return isNaN(i);
        case 6:
          return isNaN(i) || 1 > i;
      }
    return !1;
  }
  function _(t, i, s, a, f, h, y) {
    ((this.acceptsBooleans = i === 2 || i === 3 || i === 4),
      (this.attributeName = a),
      (this.attributeNamespace = f),
      (this.mustUseProperty = s),
      (this.propertyName = t),
      (this.type = i),
      (this.sanitizeURL = h),
      (this.removeEmptyString = y));
  }
  var E = {};
  ("children dangerouslySetInnerHTML defaultValue defaultChecked innerHTML suppressContentEditableWarning suppressHydrationWarning style"
    .split(" ")
    .forEach(function (t) {
      E[t] = new _(t, 0, !1, t, null, !1, !1);
    }),
    [
      ["acceptCharset", "accept-charset"],
      ["className", "class"],
      ["htmlFor", "for"],
      ["httpEquiv", "http-equiv"],
    ].forEach(function (t) {
      var i = t[0];
      E[i] = new _(i, 1, !1, t[1], null, !1, !1);
    }),
    ["contentEditable", "draggable", "spellCheck", "value"].forEach(
      function (t) {
        E[t] = new _(t, 2, !1, t.toLowerCase(), null, !1, !1);
      },
    ),
    [
      "autoReverse",
      "externalResourcesRequired",
      "focusable",
      "preserveAlpha",
    ].forEach(function (t) {
      E[t] = new _(t, 2, !1, t, null, !1, !1);
    }),
    "allowFullScreen async autoFocus autoPlay controls default defer disabled disablePictureInPicture disableRemotePlayback formNoValidate hidden loop noModule noValidate open playsInline readOnly required reversed scoped seamless itemScope"
      .split(" ")
      .forEach(function (t) {
        E[t] = new _(t, 3, !1, t.toLowerCase(), null, !1, !1);
      }),
    ["checked", "multiple", "muted", "selected"].forEach(function (t) {
      E[t] = new _(t, 3, !0, t, null, !1, !1);
    }),
    ["capture", "download"].forEach(function (t) {
      E[t] = new _(t, 4, !1, t, null, !1, !1);
    }),
    ["cols", "rows", "size", "span"].forEach(function (t) {
      E[t] = new _(t, 6, !1, t, null, !1, !1);
    }),
    ["rowSpan", "start"].forEach(function (t) {
      E[t] = new _(t, 5, !1, t.toLowerCase(), null, !1, !1);
    }));
  var T = /[\-:]([a-z])/g;
  function D(t) {
    return t[1].toUpperCase();
  }
  ("accent-height alignment-baseline arabic-form baseline-shift cap-height clip-path clip-rule color-interpolation color-interpolation-filters color-profile color-rendering dominant-baseline enable-background fill-opacity fill-rule flood-color flood-opacity font-family font-size font-size-adjust font-stretch font-style font-variant font-weight glyph-name glyph-orientation-horizontal glyph-orientation-vertical horiz-adv-x horiz-origin-x image-rendering letter-spacing lighting-color marker-end marker-mid marker-start overline-position overline-thickness paint-order panose-1 pointer-events rendering-intent shape-rendering stop-color stop-opacity strikethrough-position strikethrough-thickness stroke-dasharray stroke-dashoffset stroke-linecap stroke-linejoin stroke-miterlimit stroke-opacity stroke-width text-anchor text-decoration text-rendering underline-position underline-thickness unicode-bidi unicode-range units-per-em v-alphabetic v-hanging v-ideographic v-mathematical vector-effect vert-adv-y vert-origin-x vert-origin-y word-spacing writing-mode xmlns:xlink x-height"
    .split(" ")
    .forEach(function (t) {
      var i = t.replace(T, D);
      E[i] = new _(i, 1, !1, t, null, !1, !1);
    }),
    "xlink:actuate xlink:arcrole xlink:role xlink:show xlink:title xlink:type"
      .split(" ")
      .forEach(function (t) {
        var i = t.replace(T, D);
        E[i] = new _(i, 1, !1, t, "http://www.w3.org/1999/xlink", !1, !1);
      }),
    ["xml:base", "xml:lang", "xml:space"].forEach(function (t) {
      var i = t.replace(T, D);
      E[i] = new _(i, 1, !1, t, "http://www.w3.org/XML/1998/namespace", !1, !1);
    }),
    ["tabIndex", "crossOrigin"].forEach(function (t) {
      E[t] = new _(t, 1, !1, t.toLowerCase(), null, !1, !1);
    }),
    (E.xlinkHref = new _(
      "xlinkHref",
      1,
      !1,
      "xlink:href",
      "http://www.w3.org/1999/xlink",
      !0,
      !1,
    )),
    ["src", "href", "action", "formAction"].forEach(function (t) {
      E[t] = new _(t, 1, !1, t.toLowerCase(), null, !0, !0);
    }));
  function I(t, i, s, a) {
    var f = E.hasOwnProperty(i) ? E[i] : null;
    (f !== null
      ? f.type !== 0
      : a ||
        !(2 < i.length) ||
        (i[0] !== "o" && i[0] !== "O") ||
        (i[1] !== "n" && i[1] !== "N")) &&
      (b(i, s, f, a) && (s = null),
      a || f === null
        ? C(i) &&
          (s === null ? t.removeAttribute(i) : t.setAttribute(i, "" + s))
        : f.mustUseProperty
          ? (t[f.propertyName] = s === null ? (f.type === 3 ? !1 : "") : s)
          : ((i = f.attributeName),
            (a = f.attributeNamespace),
            s === null
              ? t.removeAttribute(i)
              : ((f = f.type),
                (s = f === 3 || (f === 4 && s === !0) ? "" : "" + s),
                a ? t.setAttributeNS(a, i, s) : t.setAttribute(i, s))));
  }
  var R = n.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED,
    N = Symbol.for("react.element"),
    F = Symbol.for("react.portal"),
    V = Symbol.for("react.fragment"),
    ie = Symbol.for("react.strict_mode"),
    he = Symbol.for("react.profiler"),
    _e = Symbol.for("react.provider"),
    Se = Symbol.for("react.context"),
    We = Symbol.for("react.forward_ref"),
    Be = Symbol.for("react.suspense"),
    pe = Symbol.for("react.suspense_list"),
    qe = Symbol.for("react.memo"),
    ft = Symbol.for("react.lazy"),
    Ee = Symbol.for("react.offscreen"),
    W = Symbol.iterator;
  function X(t) {
    return t === null || typeof t != "object"
      ? null
      : ((t = (W && t[W]) || t["@@iterator"]),
        typeof t == "function" ? t : null);
  }
  var q = Object.assign,
    P;
  function L(t) {
    if (P === void 0)
      try {
        throw Error();
      } catch (s) {
        var i = s.stack.trim().match(/\n( *(at )?)/);
        P = (i && i[1]) || "";
      }
    return (
      `
` +
      P +
      t
    );
  }
  var le = !1;
  function ae(t, i) {
    if (!t || le) return "";
    le = !0;
    var s = Error.prepareStackTrace;
    Error.prepareStackTrace = void 0;
    try {
      if (i)
        if (
          ((i = function () {
            throw Error();
          }),
          Object.defineProperty(i.prototype, "props", {
            set: function () {
              throw Error();
            },
          }),
          typeof Reflect == "object" && Reflect.construct)
        ) {
          try {
            Reflect.construct(i, []);
          } catch (M) {
            var a = M;
          }
          Reflect.construct(t, [], i);
        } else {
          try {
            i.call();
          } catch (M) {
            a = M;
          }
          t.call(i.prototype);
        }
      else {
        try {
          throw Error();
        } catch (M) {
          a = M;
        }
        t();
      }
    } catch (M) {
      if (M && a && typeof M.stack == "string") {
        for (
          var f = M.stack.split(`
`),
            h = a.stack.split(`
`),
            y = f.length - 1,
            w = h.length - 1;
          1 <= y && 0 <= w && f[y] !== h[w];
        )
          w--;
        for (; 1 <= y && 0 <= w; y--, w--)
          if (f[y] !== h[w]) {
            if (y !== 1 || w !== 1)
              do
                if ((y--, w--, 0 > w || f[y] !== h[w])) {
                  var k =
                    `
` + f[y].replace(" at new ", " at ");
                  return (
                    t.displayName &&
                      k.includes("<anonymous>") &&
                      (k = k.replace("<anonymous>", t.displayName)),
                    k
                  );
                }
              while (1 <= y && 0 <= w);
            break;
          }
      }
    } finally {
      ((le = !1), (Error.prepareStackTrace = s));
    }
    return (t = t ? t.displayName || t.name : "") ? L(t) : "";
  }
  function de(t) {
    switch (t.tag) {
      case 5:
        return L(t.type);
      case 16:
        return L("Lazy");
      case 13:
        return L("Suspense");
      case 19:
        return L("SuspenseList");
      case 0:
      case 2:
      case 15:
        return ((t = ae(t.type, !1)), t);
      case 11:
        return ((t = ae(t.type.render, !1)), t);
      case 1:
        return ((t = ae(t.type, !0)), t);
      default:
        return "";
    }
  }
  function ce(t) {
    if (t == null) return null;
    if (typeof t == "function") return t.displayName || t.name || null;
    if (typeof t == "string") return t;
    switch (t) {
      case V:
        return "Fragment";
      case F:
        return "Portal";
      case he:
        return "Profiler";
      case ie:
        return "StrictMode";
      case Be:
        return "Suspense";
      case pe:
        return "SuspenseList";
    }
    if (typeof t == "object")
      switch (t.$$typeof) {
        case Se:
          return (t.displayName || "Context") + ".Consumer";
        case _e:
          return (t._context.displayName || "Context") + ".Provider";
        case We:
          var i = t.render;
          return (
            (t = t.displayName),
            t ||
              ((t = i.displayName || i.name || ""),
              (t = t !== "" ? "ForwardRef(" + t + ")" : "ForwardRef")),
            t
          );
        case qe:
          return (
            (i = t.displayName || null),
            i !== null ? i : ce(t.type) || "Memo"
          );
        case ft:
          ((i = t._payload), (t = t._init));
          try {
            return ce(t(i));
          } catch {}
      }
    return null;
  }
  function xe(t) {
    var i = t.type;
    switch (t.tag) {
      case 24:
        return "Cache";
      case 9:
        return (i.displayName || "Context") + ".Consumer";
      case 10:
        return (i._context.displayName || "Context") + ".Provider";
      case 18:
        return "DehydratedFragment";
      case 11:
        return (
          (t = i.render),
          (t = t.displayName || t.name || ""),
          i.displayName || (t !== "" ? "ForwardRef(" + t + ")" : "ForwardRef")
        );
      case 7:
        return "Fragment";
      case 5:
        return i;
      case 4:
        return "Portal";
      case 3:
        return "Root";
      case 6:
        return "Text";
      case 16:
        return ce(i);
      case 8:
        return i === ie ? "StrictMode" : "Mode";
      case 22:
        return "Offscreen";
      case 12:
        return "Profiler";
      case 21:
        return "Scope";
      case 13:
        return "Suspense";
      case 19:
        return "SuspenseList";
      case 25:
        return "TracingMarker";
      case 1:
      case 0:
      case 17:
      case 2:
      case 14:
      case 15:
        if (typeof i == "function") return i.displayName || i.name || null;
        if (typeof i == "string") return i;
    }
    return null;
  }
  function ye(t) {
    switch (typeof t) {
      case "boolean":
      case "number":
      case "string":
      case "undefined":
        return t;
      case "object":
        return t;
      default:
        return "";
    }
  }
  function Ce(t) {
    var i = t.type;
    return (
      (t = t.nodeName) &&
      t.toLowerCase() === "input" &&
      (i === "checkbox" || i === "radio")
    );
  }
  function it(t) {
    var i = Ce(t) ? "checked" : "value",
      s = Object.getOwnPropertyDescriptor(t.constructor.prototype, i),
      a = "" + t[i];
    if (
      !t.hasOwnProperty(i) &&
      typeof s < "u" &&
      typeof s.get == "function" &&
      typeof s.set == "function"
    ) {
      var f = s.get,
        h = s.set;
      return (
        Object.defineProperty(t, i, {
          configurable: !0,
          get: function () {
            return f.call(this);
          },
          set: function (y) {
            ((a = "" + y), h.call(this, y));
          },
        }),
        Object.defineProperty(t, i, { enumerable: s.enumerable }),
        {
          getValue: function () {
            return a;
          },
          setValue: function (y) {
            a = "" + y;
          },
          stopTracking: function () {
            ((t._valueTracker = null), delete t[i]);
          },
        }
      );
    }
  }
  function Pn(t) {
    t._valueTracker || (t._valueTracker = it(t));
  }
  function Xt(t) {
    if (!t) return !1;
    var i = t._valueTracker;
    if (!i) return !0;
    var s = i.getValue(),
      a = "";
    return (
      t && (a = Ce(t) ? (t.checked ? "true" : "false") : t.value),
      (t = a),
      t !== s ? (i.setValue(t), !0) : !1
    );
  }
  function es(t) {
    if (
      ((t = t || (typeof document < "u" ? document : void 0)), typeof t > "u")
    )
      return null;
    try {
      return t.activeElement || t.body;
    } catch {
      return t.body;
    }
  }
  function ua(t, i) {
    var s = i.checked;
    return q({}, i, {
      defaultChecked: void 0,
      defaultValue: void 0,
      value: void 0,
      checked: s ?? t._wrapperState.initialChecked,
    });
  }
  function b3(t, i) {
    var s = i.defaultValue == null ? "" : i.defaultValue,
      a = i.checked != null ? i.checked : i.defaultChecked;
    ((s = ye(i.value != null ? i.value : s)),
      (t._wrapperState = {
        initialChecked: a,
        initialValue: s,
        controlled:
          i.type === "checkbox" || i.type === "radio"
            ? i.checked != null
            : i.value != null,
      }));
  }
  function k3(t, i) {
    ((i = i.checked), i != null && I(t, "checked", i, !1));
  }
  function ca(t, i) {
    k3(t, i);
    var s = ye(i.value),
      a = i.type;
    if (s != null)
      a === "number"
        ? ((s === 0 && t.value === "") || t.value != s) && (t.value = "" + s)
        : t.value !== "" + s && (t.value = "" + s);
    else if (a === "submit" || a === "reset") {
      t.removeAttribute("value");
      return;
    }
    (i.hasOwnProperty("value")
      ? fa(t, i.type, s)
      : i.hasOwnProperty("defaultValue") && fa(t, i.type, ye(i.defaultValue)),
      i.checked == null &&
        i.defaultChecked != null &&
        (t.defaultChecked = !!i.defaultChecked));
  }
  function S3(t, i, s) {
    if (i.hasOwnProperty("value") || i.hasOwnProperty("defaultValue")) {
      var a = i.type;
      if (!(
        (a !== "submit" && a !== "reset") ||
        (i.value !== void 0 && i.value !== null)
      ))
        return;
      ((i = "" + t._wrapperState.initialValue),
        s || i === t.value || (t.value = i),
        (t.defaultValue = i));
    }
    ((s = t.name),
      s !== "" && (t.name = ""),
      (t.defaultChecked = !!t._wrapperState.initialChecked),
      s !== "" && (t.name = s));
  }
  function fa(t, i, s) {
    (i !== "number" || es(t.ownerDocument) !== t) &&
      (s == null
        ? (t.defaultValue = "" + t._wrapperState.initialValue)
        : t.defaultValue !== "" + s && (t.defaultValue = "" + s));
  }
  var Zr = Array.isArray;
  function Zi(t, i, s, a) {
    if (((t = t.options), i)) {
      i = {};
      for (var f = 0; f < s.length; f++) i["$" + s[f]] = !0;
      for (s = 0; s < t.length; s++)
        ((f = i.hasOwnProperty("$" + t[s].value)),
          t[s].selected !== f && (t[s].selected = f),
          f && a && (t[s].defaultSelected = !0));
    } else {
      for (s = "" + ye(s), i = null, f = 0; f < t.length; f++) {
        if (t[f].value === s) {
          ((t[f].selected = !0), a && (t[f].defaultSelected = !0));
          return;
        }
        i !== null || t[f].disabled || (i = t[f]);
      }
      i !== null && (i.selected = !0);
    }
  }
  function da(t, i) {
    if (i.dangerouslySetInnerHTML != null) throw Error(r(91));
    return q({}, i, {
      value: void 0,
      defaultValue: void 0,
      children: "" + t._wrapperState.initialValue,
    });
  }
  function E3(t, i) {
    var s = i.value;
    if (s == null) {
      if (((s = i.children), (i = i.defaultValue), s != null)) {
        if (i != null) throw Error(r(92));
        if (Zr(s)) {
          if (1 < s.length) throw Error(r(93));
          s = s[0];
        }
        i = s;
      }
      (i == null && (i = ""), (s = i));
    }
    t._wrapperState = { initialValue: ye(s) };
  }
  function P3(t, i) {
    var s = ye(i.value),
      a = ye(i.defaultValue);
    (s != null &&
      ((s = "" + s),
      s !== t.value && (t.value = s),
      i.defaultValue == null && t.defaultValue !== s && (t.defaultValue = s)),
      a != null && (t.defaultValue = "" + a));
  }
  function z3(t) {
    var i = t.textContent;
    i === t._wrapperState.initialValue &&
      i !== "" &&
      i !== null &&
      (t.value = i);
  }
  function O3(t) {
    switch (t) {
      case "svg":
        return "http://www.w3.org/2000/svg";
      case "math":
        return "http://www.w3.org/1998/Math/MathML";
      default:
        return "http://www.w3.org/1999/xhtml";
    }
  }
  function ha(t, i) {
    return t == null || t === "http://www.w3.org/1999/xhtml"
      ? O3(i)
      : t === "http://www.w3.org/2000/svg" && i === "foreignObject"
        ? "http://www.w3.org/1999/xhtml"
        : t;
  }
  var ts,
    M3 = (function (t) {
      return typeof MSApp < "u" && MSApp.execUnsafeLocalFunction
        ? function (i, s, a, f) {
            MSApp.execUnsafeLocalFunction(function () {
              return t(i, s, a, f);
            });
          }
        : t;
    })(function (t, i) {
      if (t.namespaceURI !== "http://www.w3.org/2000/svg" || "innerHTML" in t)
        t.innerHTML = i;
      else {
        for (
          ts = ts || document.createElement("div"),
            ts.innerHTML = "<svg>" + i.valueOf().toString() + "</svg>",
            i = ts.firstChild;
          t.firstChild;
        )
          t.removeChild(t.firstChild);
        for (; i.firstChild;) t.appendChild(i.firstChild);
      }
    });
  function Kr(t, i) {
    if (i) {
      var s = t.firstChild;
      if (s && s === t.lastChild && s.nodeType === 3) {
        s.nodeValue = i;
        return;
      }
    }
    t.textContent = i;
  }
  var Yr = {
      animationIterationCount: !0,
      aspectRatio: !0,
      borderImageOutset: !0,
      borderImageSlice: !0,
      borderImageWidth: !0,
      boxFlex: !0,
      boxFlexGroup: !0,
      boxOrdinalGroup: !0,
      columnCount: !0,
      columns: !0,
      flex: !0,
      flexGrow: !0,
      flexPositive: !0,
      flexShrink: !0,
      flexNegative: !0,
      flexOrder: !0,
      gridArea: !0,
      gridRow: !0,
      gridRowEnd: !0,
      gridRowSpan: !0,
      gridRowStart: !0,
      gridColumn: !0,
      gridColumnEnd: !0,
      gridColumnSpan: !0,
      gridColumnStart: !0,
      fontWeight: !0,
      lineClamp: !0,
      lineHeight: !0,
      opacity: !0,
      order: !0,
      orphans: !0,
      tabSize: !0,
      widows: !0,
      zIndex: !0,
      zoom: !0,
      fillOpacity: !0,
      floodOpacity: !0,
      stopOpacity: !0,
      strokeDasharray: !0,
      strokeDashoffset: !0,
      strokeMiterlimit: !0,
      strokeOpacity: !0,
      strokeWidth: !0,
    },
    Z1 = ["Webkit", "ms", "Moz", "O"];
  Object.keys(Yr).forEach(function (t) {
    Z1.forEach(function (i) {
      ((i = i + t.charAt(0).toUpperCase() + t.substring(1)), (Yr[i] = Yr[t]));
    });
  });
  function R3(t, i, s) {
    return i == null || typeof i == "boolean" || i === ""
      ? ""
      : s || typeof i != "number" || i === 0 || (Yr.hasOwnProperty(t) && Yr[t])
        ? ("" + i).trim()
        : i + "px";
  }
  function D3(t, i) {
    t = t.style;
    for (var s in i)
      if (i.hasOwnProperty(s)) {
        var a = s.indexOf("--") === 0,
          f = R3(s, i[s], a);
        (s === "float" && (s = "cssFloat"),
          a ? t.setProperty(s, f) : (t[s] = f));
      }
  }
  var K1 = q(
    { menuitem: !0 },
    {
      area: !0,
      base: !0,
      br: !0,
      col: !0,
      embed: !0,
      hr: !0,
      img: !0,
      input: !0,
      keygen: !0,
      link: !0,
      meta: !0,
      param: !0,
      source: !0,
      track: !0,
      wbr: !0,
    },
  );
  function pa(t, i) {
    if (i) {
      if (K1[t] && (i.children != null || i.dangerouslySetInnerHTML != null))
        throw Error(r(137, t));
      if (i.dangerouslySetInnerHTML != null) {
        if (i.children != null) throw Error(r(60));
        if (
          typeof i.dangerouslySetInnerHTML != "object" ||
          !("__html" in i.dangerouslySetInnerHTML)
        )
          throw Error(r(61));
      }
      if (i.style != null && typeof i.style != "object") throw Error(r(62));
    }
  }
  function ma(t, i) {
    if (t.indexOf("-") === -1) return typeof i.is == "string";
    switch (t) {
      case "annotation-xml":
      case "color-profile":
      case "font-face":
      case "font-face-src":
      case "font-face-uri":
      case "font-face-format":
      case "font-face-name":
      case "missing-glyph":
        return !1;
      default:
        return !0;
    }
  }
  var ya = null;
  function ga(t) {
    return (
      (t = t.target || t.srcElement || window),
      t.correspondingUseElement && (t = t.correspondingUseElement),
      t.nodeType === 3 ? t.parentNode : t
    );
  }
  var va = null,
    Ki = null,
    Yi = null;
  function T3(t) {
    if ((t = wo(t))) {
      if (typeof va != "function") throw Error(r(280));
      var i = t.stateNode;
      i && ((i = ks(i)), va(t.stateNode, t.type, i));
    }
  }
  function I3(t) {
    Ki ? (Yi ? Yi.push(t) : (Yi = [t])) : (Ki = t);
  }
  function L3() {
    if (Ki) {
      var t = Ki,
        i = Yi;
      if (((Yi = Ki = null), T3(t), i)) for (t = 0; t < i.length; t++) T3(i[t]);
    }
  }
  function F3(t, i) {
    return t(i);
  }
  function A3() {}
  var Ca = !1;
  function N3(t, i, s) {
    if (Ca) return t(i, s);
    Ca = !0;
    try {
      return F3(t, i, s);
    } finally {
      ((Ca = !1), (Ki !== null || Yi !== null) && (A3(), L3()));
    }
  }
  function Xr(t, i) {
    var s = t.stateNode;
    if (s === null) return null;
    var a = ks(s);
    if (a === null) return null;
    s = a[i];
    e: switch (i) {
      case "onClick":
      case "onClickCapture":
      case "onDoubleClick":
      case "onDoubleClickCapture":
      case "onMouseDown":
      case "onMouseDownCapture":
      case "onMouseMove":
      case "onMouseMoveCapture":
      case "onMouseUp":
      case "onMouseUpCapture":
      case "onMouseEnter":
        ((a = !a.disabled) ||
          ((t = t.type),
          (a = !(
            t === "button" ||
            t === "input" ||
            t === "select" ||
            t === "textarea"
          ))),
          (t = !a));
        break e;
      default:
        t = !1;
    }
    if (t) return null;
    if (s && typeof s != "function") throw Error(r(231, i, typeof s));
    return s;
  }
  var wa = !1;
  if (d)
    try {
      var Jr = {};
      (Object.defineProperty(Jr, "passive", {
        get: function () {
          wa = !0;
        },
      }),
        window.addEventListener("test", Jr, Jr),
        window.removeEventListener("test", Jr, Jr));
    } catch {
      wa = !1;
    }
  function Y1(t, i, s, a, f, h, y, w, k) {
    var M = Array.prototype.slice.call(arguments, 3);
    try {
      i.apply(s, M);
    } catch (j) {
      this.onError(j);
    }
  }
  var eo = !1,
    ns = null,
    is = !1,
    xa = null,
    X1 = {
      onError: function (t) {
        ((eo = !0), (ns = t));
      },
    };
  function J1(t, i, s, a, f, h, y, w, k) {
    ((eo = !1), (ns = null), Y1.apply(X1, arguments));
  }
  function e5(t, i, s, a, f, h, y, w, k) {
    if ((J1.apply(this, arguments), eo)) {
      if (eo) {
        var M = ns;
        ((eo = !1), (ns = null));
      } else throw Error(r(198));
      is || ((is = !0), (xa = M));
    }
  }
  function yi(t) {
    var i = t,
      s = t;
    if (t.alternate) for (; i.return;) i = i.return;
    else {
      t = i;
      do ((i = t), i.flags & 4098 && (s = i.return), (t = i.return));
      while (t);
    }
    return i.tag === 3 ? s : null;
  }
  function $3(t) {
    if (t.tag === 13) {
      var i = t.memoizedState;
      if (
        (i === null && ((t = t.alternate), t !== null && (i = t.memoizedState)),
        i !== null)
      )
        return i.dehydrated;
    }
    return null;
  }
  function j3(t) {
    if (yi(t) !== t) throw Error(r(188));
  }
  function t5(t) {
    var i = t.alternate;
    if (!i) {
      if (((i = yi(t)), i === null)) throw Error(r(188));
      return i !== t ? null : t;
    }
    for (var s = t, a = i; ;) {
      var f = s.return;
      if (f === null) break;
      var h = f.alternate;
      if (h === null) {
        if (((a = f.return), a !== null)) {
          s = a;
          continue;
        }
        break;
      }
      if (f.child === h.child) {
        for (h = f.child; h;) {
          if (h === s) return (j3(f), t);
          if (h === a) return (j3(f), i);
          h = h.sibling;
        }
        throw Error(r(188));
      }
      if (s.return !== a.return) ((s = f), (a = h));
      else {
        for (var y = !1, w = f.child; w;) {
          if (w === s) {
            ((y = !0), (s = f), (a = h));
            break;
          }
          if (w === a) {
            ((y = !0), (a = f), (s = h));
            break;
          }
          w = w.sibling;
        }
        if (!y) {
          for (w = h.child; w;) {
            if (w === s) {
              ((y = !0), (s = h), (a = f));
              break;
            }
            if (w === a) {
              ((y = !0), (a = h), (s = f));
              break;
            }
            w = w.sibling;
          }
          if (!y) throw Error(r(189));
        }
      }
      if (s.alternate !== a) throw Error(r(190));
    }
    if (s.tag !== 3) throw Error(r(188));
    return s.stateNode.current === s ? t : i;
  }
  function B3(t) {
    return ((t = t5(t)), t !== null ? U3(t) : null);
  }
  function U3(t) {
    if (t.tag === 5 || t.tag === 6) return t;
    for (t = t.child; t !== null;) {
      var i = U3(t);
      if (i !== null) return i;
      t = t.sibling;
    }
    return null;
  }
  var H3 = e.unstable_scheduleCallback,
    V3 = e.unstable_cancelCallback,
    n5 = e.unstable_shouldYield,
    i5 = e.unstable_requestPaint,
    Ue = e.unstable_now,
    r5 = e.unstable_getCurrentPriorityLevel,
    _a = e.unstable_ImmediatePriority,
    W3 = e.unstable_UserBlockingPriority,
    rs = e.unstable_NormalPriority,
    o5 = e.unstable_LowPriority,
    q3 = e.unstable_IdlePriority,
    os = null,
    mn = null;
  function s5(t) {
    if (mn && typeof mn.onCommitFiberRoot == "function")
      try {
        mn.onCommitFiberRoot(os, t, void 0, (t.current.flags & 128) === 128);
      } catch {}
  }
  var Jt = Math.clz32 ? Math.clz32 : u5,
    l5 = Math.log,
    a5 = Math.LN2;
  function u5(t) {
    return ((t >>>= 0), t === 0 ? 32 : (31 - ((l5(t) / a5) | 0)) | 0);
  }
  var ss = 64,
    ls = 4194304;
  function to(t) {
    switch (t & -t) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 4:
        return 4;
      case 8:
        return 8;
      case 16:
        return 16;
      case 32:
        return 32;
      case 64:
      case 128:
      case 256:
      case 512:
      case 1024:
      case 2048:
      case 4096:
      case 8192:
      case 16384:
      case 32768:
      case 65536:
      case 131072:
      case 262144:
      case 524288:
      case 1048576:
      case 2097152:
        return t & 4194240;
      case 4194304:
      case 8388608:
      case 16777216:
      case 33554432:
      case 67108864:
        return t & 130023424;
      case 134217728:
        return 134217728;
      case 268435456:
        return 268435456;
      case 536870912:
        return 536870912;
      case 1073741824:
        return 1073741824;
      default:
        return t;
    }
  }
  function as(t, i) {
    var s = t.pendingLanes;
    if (s === 0) return 0;
    var a = 0,
      f = t.suspendedLanes,
      h = t.pingedLanes,
      y = s & 268435455;
    if (y !== 0) {
      var w = y & ~f;
      w !== 0 ? (a = to(w)) : ((h &= y), h !== 0 && (a = to(h)));
    } else ((y = s & ~f), y !== 0 ? (a = to(y)) : h !== 0 && (a = to(h)));
    if (a === 0) return 0;
    if (
      i !== 0 &&
      i !== a &&
      !(i & f) &&
      ((f = a & -a), (h = i & -i), f >= h || (f === 16 && (h & 4194240) !== 0))
    )
      return i;
    if ((a & 4 && (a |= s & 16), (i = t.entangledLanes), i !== 0))
      for (t = t.entanglements, i &= a; 0 < i;)
        ((s = 31 - Jt(i)), (f = 1 << s), (a |= t[s]), (i &= ~f));
    return a;
  }
  function c5(t, i) {
    switch (t) {
      case 1:
      case 2:
      case 4:
        return i + 250;
      case 8:
      case 16:
      case 32:
      case 64:
      case 128:
      case 256:
      case 512:
      case 1024:
      case 2048:
      case 4096:
      case 8192:
      case 16384:
      case 32768:
      case 65536:
      case 131072:
      case 262144:
      case 524288:
      case 1048576:
      case 2097152:
        return i + 5e3;
      case 4194304:
      case 8388608:
      case 16777216:
      case 33554432:
      case 67108864:
        return -1;
      case 134217728:
      case 268435456:
      case 536870912:
      case 1073741824:
        return -1;
      default:
        return -1;
    }
  }
  function f5(t, i) {
    for (
      var s = t.suspendedLanes,
        a = t.pingedLanes,
        f = t.expirationTimes,
        h = t.pendingLanes;
      0 < h;
    ) {
      var y = 31 - Jt(h),
        w = 1 << y,
        k = f[y];
      (k === -1
        ? (!(w & s) || w & a) && (f[y] = c5(w, i))
        : k <= i && (t.expiredLanes |= w),
        (h &= ~w));
    }
  }
  function ba(t) {
    return (
      (t = t.pendingLanes & -1073741825),
      t !== 0 ? t : t & 1073741824 ? 1073741824 : 0
    );
  }
  function G3() {
    var t = ss;
    return ((ss <<= 1), !(ss & 4194240) && (ss = 64), t);
  }
  function ka(t) {
    for (var i = [], s = 0; 31 > s; s++) i.push(t);
    return i;
  }
  function no(t, i, s) {
    ((t.pendingLanes |= i),
      i !== 536870912 && ((t.suspendedLanes = 0), (t.pingedLanes = 0)),
      (t = t.eventTimes),
      (i = 31 - Jt(i)),
      (t[i] = s));
  }
  function d5(t, i) {
    var s = t.pendingLanes & ~i;
    ((t.pendingLanes = i),
      (t.suspendedLanes = 0),
      (t.pingedLanes = 0),
      (t.expiredLanes &= i),
      (t.mutableReadLanes &= i),
      (t.entangledLanes &= i),
      (i = t.entanglements));
    var a = t.eventTimes;
    for (t = t.expirationTimes; 0 < s;) {
      var f = 31 - Jt(s),
        h = 1 << f;
      ((i[f] = 0), (a[f] = -1), (t[f] = -1), (s &= ~h));
    }
  }
  function Sa(t, i) {
    var s = (t.entangledLanes |= i);
    for (t = t.entanglements; s;) {
      var a = 31 - Jt(s),
        f = 1 << a;
      ((f & i) | (t[a] & i) && (t[a] |= i), (s &= ~f));
    }
  }
  var ke = 0;
  function Q3(t) {
    return (
      (t &= -t),
      1 < t ? (4 < t ? (t & 268435455 ? 16 : 536870912) : 4) : 1
    );
  }
  var Z3,
    Ea,
    K3,
    Y3,
    X3,
    Pa = !1,
    us = [],
    Bn = null,
    Un = null,
    Hn = null,
    io = new Map(),
    ro = new Map(),
    Vn = [],
    h5 =
      "mousedown mouseup touchcancel touchend touchstart auxclick dblclick pointercancel pointerdown pointerup dragend dragstart drop compositionend compositionstart keydown keypress keyup input textInput copy cut paste click change contextmenu reset submit".split(
        " ",
      );
  function J3(t, i) {
    switch (t) {
      case "focusin":
      case "focusout":
        Bn = null;
        break;
      case "dragenter":
      case "dragleave":
        Un = null;
        break;
      case "mouseover":
      case "mouseout":
        Hn = null;
        break;
      case "pointerover":
      case "pointerout":
        io.delete(i.pointerId);
        break;
      case "gotpointercapture":
      case "lostpointercapture":
        ro.delete(i.pointerId);
    }
  }
  function oo(t, i, s, a, f, h) {
    return t === null || t.nativeEvent !== h
      ? ((t = {
          blockedOn: i,
          domEventName: s,
          eventSystemFlags: a,
          nativeEvent: h,
          targetContainers: [f],
        }),
        i !== null && ((i = wo(i)), i !== null && Ea(i)),
        t)
      : ((t.eventSystemFlags |= a),
        (i = t.targetContainers),
        f !== null && i.indexOf(f) === -1 && i.push(f),
        t);
  }
  function p5(t, i, s, a, f) {
    switch (i) {
      case "focusin":
        return ((Bn = oo(Bn, t, i, s, a, f)), !0);
      case "dragenter":
        return ((Un = oo(Un, t, i, s, a, f)), !0);
      case "mouseover":
        return ((Hn = oo(Hn, t, i, s, a, f)), !0);
      case "pointerover":
        var h = f.pointerId;
        return (io.set(h, oo(io.get(h) || null, t, i, s, a, f)), !0);
      case "gotpointercapture":
        return (
          (h = f.pointerId),
          ro.set(h, oo(ro.get(h) || null, t, i, s, a, f)),
          !0
        );
    }
    return !1;
  }
  function e9(t) {
    var i = gi(t.target);
    if (i !== null) {
      var s = yi(i);
      if (s !== null) {
        if (((i = s.tag), i === 13)) {
          if (((i = $3(s)), i !== null)) {
            ((t.blockedOn = i),
              X3(t.priority, function () {
                K3(s);
              }));
            return;
          }
        } else if (i === 3 && s.stateNode.current.memoizedState.isDehydrated) {
          t.blockedOn = s.tag === 3 ? s.stateNode.containerInfo : null;
          return;
        }
      }
    }
    t.blockedOn = null;
  }
  function cs(t) {
    if (t.blockedOn !== null) return !1;
    for (var i = t.targetContainers; 0 < i.length;) {
      var s = Oa(t.domEventName, t.eventSystemFlags, i[0], t.nativeEvent);
      if (s === null) {
        s = t.nativeEvent;
        var a = new s.constructor(s.type, s);
        ((ya = a), s.target.dispatchEvent(a), (ya = null));
      } else return ((i = wo(s)), i !== null && Ea(i), (t.blockedOn = s), !1);
      i.shift();
    }
    return !0;
  }
  function t9(t, i, s) {
    cs(t) && s.delete(i);
  }
  function m5() {
    ((Pa = !1),
      Bn !== null && cs(Bn) && (Bn = null),
      Un !== null && cs(Un) && (Un = null),
      Hn !== null && cs(Hn) && (Hn = null),
      io.forEach(t9),
      ro.forEach(t9));
  }
  function so(t, i) {
    t.blockedOn === i &&
      ((t.blockedOn = null),
      Pa ||
        ((Pa = !0),
        e.unstable_scheduleCallback(e.unstable_NormalPriority, m5)));
  }
  function lo(t) {
    function i(f) {
      return so(f, t);
    }
    if (0 < us.length) {
      so(us[0], t);
      for (var s = 1; s < us.length; s++) {
        var a = us[s];
        a.blockedOn === t && (a.blockedOn = null);
      }
    }
    for (
      Bn !== null && so(Bn, t),
        Un !== null && so(Un, t),
        Hn !== null && so(Hn, t),
        io.forEach(i),
        ro.forEach(i),
        s = 0;
      s < Vn.length;
      s++
    )
      ((a = Vn[s]), a.blockedOn === t && (a.blockedOn = null));
    for (; 0 < Vn.length && ((s = Vn[0]), s.blockedOn === null);)
      (e9(s), s.blockedOn === null && Vn.shift());
  }
  var Xi = R.ReactCurrentBatchConfig,
    fs = !0;
  function y5(t, i, s, a) {
    var f = ke,
      h = Xi.transition;
    Xi.transition = null;
    try {
      ((ke = 1), za(t, i, s, a));
    } finally {
      ((ke = f), (Xi.transition = h));
    }
  }
  function g5(t, i, s, a) {
    var f = ke,
      h = Xi.transition;
    Xi.transition = null;
    try {
      ((ke = 4), za(t, i, s, a));
    } finally {
      ((ke = f), (Xi.transition = h));
    }
  }
  function za(t, i, s, a) {
    if (fs) {
      var f = Oa(t, i, s, a);
      if (f === null) (qa(t, i, a, ds, s), J3(t, a));
      else if (p5(f, t, i, s, a)) a.stopPropagation();
      else if ((J3(t, a), i & 4 && -1 < h5.indexOf(t))) {
        for (; f !== null;) {
          var h = wo(f);
          if (
            (h !== null && Z3(h),
            (h = Oa(t, i, s, a)),
            h === null && qa(t, i, a, ds, s),
            h === f)
          )
            break;
          f = h;
        }
        f !== null && a.stopPropagation();
      } else qa(t, i, a, null, s);
    }
  }
  var ds = null;
  function Oa(t, i, s, a) {
    if (((ds = null), (t = ga(a)), (t = gi(t)), t !== null))
      if (((i = yi(t)), i === null)) t = null;
      else if (((s = i.tag), s === 13)) {
        if (((t = $3(i)), t !== null)) return t;
        t = null;
      } else if (s === 3) {
        if (i.stateNode.current.memoizedState.isDehydrated)
          return i.tag === 3 ? i.stateNode.containerInfo : null;
        t = null;
      } else i !== t && (t = null);
    return ((ds = t), null);
  }
  function n9(t) {
    switch (t) {
      case "cancel":
      case "click":
      case "close":
      case "contextmenu":
      case "copy":
      case "cut":
      case "auxclick":
      case "dblclick":
      case "dragend":
      case "dragstart":
      case "drop":
      case "focusin":
      case "focusout":
      case "input":
      case "invalid":
      case "keydown":
      case "keypress":
      case "keyup":
      case "mousedown":
      case "mouseup":
      case "paste":
      case "pause":
      case "play":
      case "pointercancel":
      case "pointerdown":
      case "pointerup":
      case "ratechange":
      case "reset":
      case "resize":
      case "seeked":
      case "submit":
      case "touchcancel":
      case "touchend":
      case "touchstart":
      case "volumechange":
      case "change":
      case "selectionchange":
      case "textInput":
      case "compositionstart":
      case "compositionend":
      case "compositionupdate":
      case "beforeblur":
      case "afterblur":
      case "beforeinput":
      case "blur":
      case "fullscreenchange":
      case "focus":
      case "hashchange":
      case "popstate":
      case "select":
      case "selectstart":
        return 1;
      case "drag":
      case "dragenter":
      case "dragexit":
      case "dragleave":
      case "dragover":
      case "mousemove":
      case "mouseout":
      case "mouseover":
      case "pointermove":
      case "pointerout":
      case "pointerover":
      case "scroll":
      case "toggle":
      case "touchmove":
      case "wheel":
      case "mouseenter":
      case "mouseleave":
      case "pointerenter":
      case "pointerleave":
        return 4;
      case "message":
        switch (r5()) {
          case _a:
            return 1;
          case W3:
            return 4;
          case rs:
          case o5:
            return 16;
          case q3:
            return 536870912;
          default:
            return 16;
        }
      default:
        return 16;
    }
  }
  var Wn = null,
    Ma = null,
    hs = null;
  function i9() {
    if (hs) return hs;
    var t,
      i = Ma,
      s = i.length,
      a,
      f = "value" in Wn ? Wn.value : Wn.textContent,
      h = f.length;
    for (t = 0; t < s && i[t] === f[t]; t++);
    var y = s - t;
    for (a = 1; a <= y && i[s - a] === f[h - a]; a++);
    return (hs = f.slice(t, 1 < a ? 1 - a : void 0));
  }
  function ps(t) {
    var i = t.keyCode;
    return (
      "charCode" in t
        ? ((t = t.charCode), t === 0 && i === 13 && (t = 13))
        : (t = i),
      t === 10 && (t = 13),
      32 <= t || t === 13 ? t : 0
    );
  }
  function ms() {
    return !0;
  }
  function r9() {
    return !1;
  }
  function Dt(t) {
    function i(s, a, f, h, y) {
      ((this._reactName = s),
        (this._targetInst = f),
        (this.type = a),
        (this.nativeEvent = h),
        (this.target = y),
        (this.currentTarget = null));
      for (var w in t)
        t.hasOwnProperty(w) && ((s = t[w]), (this[w] = s ? s(h) : h[w]));
      return (
        (this.isDefaultPrevented = (
          h.defaultPrevented != null ? h.defaultPrevented : h.returnValue === !1
        )
          ? ms
          : r9),
        (this.isPropagationStopped = r9),
        this
      );
    }
    return (
      q(i.prototype, {
        preventDefault: function () {
          this.defaultPrevented = !0;
          var s = this.nativeEvent;
          s &&
            (s.preventDefault
              ? s.preventDefault()
              : typeof s.returnValue != "unknown" && (s.returnValue = !1),
            (this.isDefaultPrevented = ms));
        },
        stopPropagation: function () {
          var s = this.nativeEvent;
          s &&
            (s.stopPropagation
              ? s.stopPropagation()
              : typeof s.cancelBubble != "unknown" && (s.cancelBubble = !0),
            (this.isPropagationStopped = ms));
        },
        persist: function () {},
        isPersistent: ms,
      }),
      i
    );
  }
  var Ji = {
      eventPhase: 0,
      bubbles: 0,
      cancelable: 0,
      timeStamp: function (t) {
        return t.timeStamp || Date.now();
      },
      defaultPrevented: 0,
      isTrusted: 0,
    },
    Ra = Dt(Ji),
    ao = q({}, Ji, { view: 0, detail: 0 }),
    v5 = Dt(ao),
    Da,
    Ta,
    uo,
    ys = q({}, ao, {
      screenX: 0,
      screenY: 0,
      clientX: 0,
      clientY: 0,
      pageX: 0,
      pageY: 0,
      ctrlKey: 0,
      shiftKey: 0,
      altKey: 0,
      metaKey: 0,
      getModifierState: La,
      button: 0,
      buttons: 0,
      relatedTarget: function (t) {
        return t.relatedTarget === void 0
          ? t.fromElement === t.srcElement
            ? t.toElement
            : t.fromElement
          : t.relatedTarget;
      },
      movementX: function (t) {
        return "movementX" in t
          ? t.movementX
          : (t !== uo &&
              (uo && t.type === "mousemove"
                ? ((Da = t.screenX - uo.screenX), (Ta = t.screenY - uo.screenY))
                : (Ta = Da = 0),
              (uo = t)),
            Da);
      },
      movementY: function (t) {
        return "movementY" in t ? t.movementY : Ta;
      },
    }),
    o9 = Dt(ys),
    C5 = q({}, ys, { dataTransfer: 0 }),
    w5 = Dt(C5),
    x5 = q({}, ao, { relatedTarget: 0 }),
    Ia = Dt(x5),
    _5 = q({}, Ji, { animationName: 0, elapsedTime: 0, pseudoElement: 0 }),
    b5 = Dt(_5),
    k5 = q({}, Ji, {
      clipboardData: function (t) {
        return "clipboardData" in t ? t.clipboardData : window.clipboardData;
      },
    }),
    S5 = Dt(k5),
    E5 = q({}, Ji, { data: 0 }),
    s9 = Dt(E5),
    P5 = {
      Esc: "Escape",
      Spacebar: " ",
      Left: "ArrowLeft",
      Up: "ArrowUp",
      Right: "ArrowRight",
      Down: "ArrowDown",
      Del: "Delete",
      Win: "OS",
      Menu: "ContextMenu",
      Apps: "ContextMenu",
      Scroll: "ScrollLock",
      MozPrintableKey: "Unidentified",
    },
    z5 = {
      8: "Backspace",
      9: "Tab",
      12: "Clear",
      13: "Enter",
      16: "Shift",
      17: "Control",
      18: "Alt",
      19: "Pause",
      20: "CapsLock",
      27: "Escape",
      32: " ",
      33: "PageUp",
      34: "PageDown",
      35: "End",
      36: "Home",
      37: "ArrowLeft",
      38: "ArrowUp",
      39: "ArrowRight",
      40: "ArrowDown",
      45: "Insert",
      46: "Delete",
      112: "F1",
      113: "F2",
      114: "F3",
      115: "F4",
      116: "F5",
      117: "F6",
      118: "F7",
      119: "F8",
      120: "F9",
      121: "F10",
      122: "F11",
      123: "F12",
      144: "NumLock",
      145: "ScrollLock",
      224: "Meta",
    },
    O5 = {
      Alt: "altKey",
      Control: "ctrlKey",
      Meta: "metaKey",
      Shift: "shiftKey",
    };
  function M5(t) {
    var i = this.nativeEvent;
    return i.getModifierState
      ? i.getModifierState(t)
      : (t = O5[t])
        ? !!i[t]
        : !1;
  }
  function La() {
    return M5;
  }
  var R5 = q({}, ao, {
      key: function (t) {
        if (t.key) {
          var i = P5[t.key] || t.key;
          if (i !== "Unidentified") return i;
        }
        return t.type === "keypress"
          ? ((t = ps(t)), t === 13 ? "Enter" : String.fromCharCode(t))
          : t.type === "keydown" || t.type === "keyup"
            ? z5[t.keyCode] || "Unidentified"
            : "";
      },
      code: 0,
      location: 0,
      ctrlKey: 0,
      shiftKey: 0,
      altKey: 0,
      metaKey: 0,
      repeat: 0,
      locale: 0,
      getModifierState: La,
      charCode: function (t) {
        return t.type === "keypress" ? ps(t) : 0;
      },
      keyCode: function (t) {
        return t.type === "keydown" || t.type === "keyup" ? t.keyCode : 0;
      },
      which: function (t) {
        return t.type === "keypress"
          ? ps(t)
          : t.type === "keydown" || t.type === "keyup"
            ? t.keyCode
            : 0;
      },
    }),
    D5 = Dt(R5),
    T5 = q({}, ys, {
      pointerId: 0,
      width: 0,
      height: 0,
      pressure: 0,
      tangentialPressure: 0,
      tiltX: 0,
      tiltY: 0,
      twist: 0,
      pointerType: 0,
      isPrimary: 0,
    }),
    l9 = Dt(T5),
    I5 = q({}, ao, {
      touches: 0,
      targetTouches: 0,
      changedTouches: 0,
      altKey: 0,
      metaKey: 0,
      ctrlKey: 0,
      shiftKey: 0,
      getModifierState: La,
    }),
    L5 = Dt(I5),
    F5 = q({}, Ji, { propertyName: 0, elapsedTime: 0, pseudoElement: 0 }),
    A5 = Dt(F5),
    N5 = q({}, ys, {
      deltaX: function (t) {
        return "deltaX" in t
          ? t.deltaX
          : "wheelDeltaX" in t
            ? -t.wheelDeltaX
            : 0;
      },
      deltaY: function (t) {
        return "deltaY" in t
          ? t.deltaY
          : "wheelDeltaY" in t
            ? -t.wheelDeltaY
            : "wheelDelta" in t
              ? -t.wheelDelta
              : 0;
      },
      deltaZ: 0,
      deltaMode: 0,
    }),
    $5 = Dt(N5),
    j5 = [9, 13, 27, 32],
    Fa = d && "CompositionEvent" in window,
    co = null;
  d && "documentMode" in document && (co = document.documentMode);
  var B5 = d && "TextEvent" in window && !co,
    a9 = d && (!Fa || (co && 8 < co && 11 >= co)),
    u9 = " ",
    c9 = !1;
  function f9(t, i) {
    switch (t) {
      case "keyup":
        return j5.indexOf(i.keyCode) !== -1;
      case "keydown":
        return i.keyCode !== 229;
      case "keypress":
      case "mousedown":
      case "focusout":
        return !0;
      default:
        return !1;
    }
  }
  function d9(t) {
    return (
      (t = t.detail),
      typeof t == "object" && "data" in t ? t.data : null
    );
  }
  var er = !1;
  function U5(t, i) {
    switch (t) {
      case "compositionend":
        return d9(i);
      case "keypress":
        return i.which !== 32 ? null : ((c9 = !0), u9);
      case "textInput":
        return ((t = i.data), t === u9 && c9 ? null : t);
      default:
        return null;
    }
  }
  function H5(t, i) {
    if (er)
      return t === "compositionend" || (!Fa && f9(t, i))
        ? ((t = i9()), (hs = Ma = Wn = null), (er = !1), t)
        : null;
    switch (t) {
      case "paste":
        return null;
      case "keypress":
        if (!(i.ctrlKey || i.altKey || i.metaKey) || (i.ctrlKey && i.altKey)) {
          if (i.char && 1 < i.char.length) return i.char;
          if (i.which) return String.fromCharCode(i.which);
        }
        return null;
      case "compositionend":
        return a9 && i.locale !== "ko" ? null : i.data;
      default:
        return null;
    }
  }
  var V5 = {
    color: !0,
    date: !0,
    datetime: !0,
    "datetime-local": !0,
    email: !0,
    month: !0,
    number: !0,
    password: !0,
    range: !0,
    search: !0,
    tel: !0,
    text: !0,
    time: !0,
    url: !0,
    week: !0,
  };
  function h9(t) {
    var i = t && t.nodeName && t.nodeName.toLowerCase();
    return i === "input" ? !!V5[t.type] : i === "textarea";
  }
  function p9(t, i, s, a) {
    (I3(a),
      (i = xs(i, "onChange")),
      0 < i.length &&
        ((s = new Ra("onChange", "change", null, s, a)),
        t.push({ event: s, listeners: i })));
  }
  var fo = null,
    ho = null;
  function W5(t) {
    D9(t, 0);
  }
  function gs(t) {
    var i = or(t);
    if (Xt(i)) return t;
  }
  function q5(t, i) {
    if (t === "change") return i;
  }
  var m9 = !1;
  if (d) {
    var Aa;
    if (d) {
      var Na = "oninput" in document;
      if (!Na) {
        var y9 = document.createElement("div");
        (y9.setAttribute("oninput", "return;"),
          (Na = typeof y9.oninput == "function"));
      }
      Aa = Na;
    } else Aa = !1;
    m9 = Aa && (!document.documentMode || 9 < document.documentMode);
  }
  function g9() {
    fo && (fo.detachEvent("onpropertychange", v9), (ho = fo = null));
  }
  function v9(t) {
    if (t.propertyName === "value" && gs(ho)) {
      var i = [];
      (p9(i, ho, t, ga(t)), N3(W5, i));
    }
  }
  function G5(t, i, s) {
    t === "focusin"
      ? (g9(), (fo = i), (ho = s), fo.attachEvent("onpropertychange", v9))
      : t === "focusout" && g9();
  }
  function Q5(t) {
    if (t === "selectionchange" || t === "keyup" || t === "keydown")
      return gs(ho);
  }
  function Z5(t, i) {
    if (t === "click") return gs(i);
  }
  function K5(t, i) {
    if (t === "input" || t === "change") return gs(i);
  }
  function Y5(t, i) {
    return (t === i && (t !== 0 || 1 / t === 1 / i)) || (t !== t && i !== i);
  }
  var en = typeof Object.is == "function" ? Object.is : Y5;
  function po(t, i) {
    if (en(t, i)) return !0;
    if (
      typeof t != "object" ||
      t === null ||
      typeof i != "object" ||
      i === null
    )
      return !1;
    var s = Object.keys(t),
      a = Object.keys(i);
    if (s.length !== a.length) return !1;
    for (a = 0; a < s.length; a++) {
      var f = s[a];
      if (!p.call(i, f) || !en(t[f], i[f])) return !1;
    }
    return !0;
  }
  function C9(t) {
    for (; t && t.firstChild;) t = t.firstChild;
    return t;
  }
  function w9(t, i) {
    var s = C9(t);
    t = 0;
    for (var a; s;) {
      if (s.nodeType === 3) {
        if (((a = t + s.textContent.length), t <= i && a >= i))
          return { node: s, offset: i - t };
        t = a;
      }
      e: {
        for (; s;) {
          if (s.nextSibling) {
            s = s.nextSibling;
            break e;
          }
          s = s.parentNode;
        }
        s = void 0;
      }
      s = C9(s);
    }
  }
  function x9(t, i) {
    return t && i
      ? t === i
        ? !0
        : t && t.nodeType === 3
          ? !1
          : i && i.nodeType === 3
            ? x9(t, i.parentNode)
            : "contains" in t
              ? t.contains(i)
              : t.compareDocumentPosition
                ? !!(t.compareDocumentPosition(i) & 16)
                : !1
      : !1;
  }
  function _9() {
    for (var t = window, i = es(); i instanceof t.HTMLIFrameElement;) {
      try {
        var s = typeof i.contentWindow.location.href == "string";
      } catch {
        s = !1;
      }
      if (s) t = i.contentWindow;
      else break;
      i = es(t.document);
    }
    return i;
  }
  function $a(t) {
    var i = t && t.nodeName && t.nodeName.toLowerCase();
    return (
      i &&
      ((i === "input" &&
        (t.type === "text" ||
          t.type === "search" ||
          t.type === "tel" ||
          t.type === "url" ||
          t.type === "password")) ||
        i === "textarea" ||
        t.contentEditable === "true")
    );
  }
  function X5(t) {
    var i = _9(),
      s = t.focusedElem,
      a = t.selectionRange;
    if (
      i !== s &&
      s &&
      s.ownerDocument &&
      x9(s.ownerDocument.documentElement, s)
    ) {
      if (a !== null && $a(s)) {
        if (
          ((i = a.start),
          (t = a.end),
          t === void 0 && (t = i),
          "selectionStart" in s)
        )
          ((s.selectionStart = i),
            (s.selectionEnd = Math.min(t, s.value.length)));
        else if (
          ((t = ((i = s.ownerDocument || document) && i.defaultView) || window),
          t.getSelection)
        ) {
          t = t.getSelection();
          var f = s.textContent.length,
            h = Math.min(a.start, f);
          ((a = a.end === void 0 ? h : Math.min(a.end, f)),
            !t.extend && h > a && ((f = a), (a = h), (h = f)),
            (f = w9(s, h)));
          var y = w9(s, a);
          f &&
            y &&
            (t.rangeCount !== 1 ||
              t.anchorNode !== f.node ||
              t.anchorOffset !== f.offset ||
              t.focusNode !== y.node ||
              t.focusOffset !== y.offset) &&
            ((i = i.createRange()),
            i.setStart(f.node, f.offset),
            t.removeAllRanges(),
            h > a
              ? (t.addRange(i), t.extend(y.node, y.offset))
              : (i.setEnd(y.node, y.offset), t.addRange(i)));
        }
      }
      for (i = [], t = s; (t = t.parentNode);)
        t.nodeType === 1 &&
          i.push({ element: t, left: t.scrollLeft, top: t.scrollTop });
      for (typeof s.focus == "function" && s.focus(), s = 0; s < i.length; s++)
        ((t = i[s]),
          (t.element.scrollLeft = t.left),
          (t.element.scrollTop = t.top));
    }
  }
  var J5 = d && "documentMode" in document && 11 >= document.documentMode,
    tr = null,
    ja = null,
    mo = null,
    Ba = !1;
  function b9(t, i, s) {
    var a =
      s.window === s ? s.document : s.nodeType === 9 ? s : s.ownerDocument;
    Ba ||
      tr == null ||
      tr !== es(a) ||
      ((a = tr),
      "selectionStart" in a && $a(a)
        ? (a = { start: a.selectionStart, end: a.selectionEnd })
        : ((a = (
            (a.ownerDocument && a.ownerDocument.defaultView) ||
            window
          ).getSelection()),
          (a = {
            anchorNode: a.anchorNode,
            anchorOffset: a.anchorOffset,
            focusNode: a.focusNode,
            focusOffset: a.focusOffset,
          })),
      (mo && po(mo, a)) ||
        ((mo = a),
        (a = xs(ja, "onSelect")),
        0 < a.length &&
          ((i = new Ra("onSelect", "select", null, i, s)),
          t.push({ event: i, listeners: a }),
          (i.target = tr))));
  }
  function vs(t, i) {
    var s = {};
    return (
      (s[t.toLowerCase()] = i.toLowerCase()),
      (s["Webkit" + t] = "webkit" + i),
      (s["Moz" + t] = "moz" + i),
      s
    );
  }
  var nr = {
      animationend: vs("Animation", "AnimationEnd"),
      animationiteration: vs("Animation", "AnimationIteration"),
      animationstart: vs("Animation", "AnimationStart"),
      transitionend: vs("Transition", "TransitionEnd"),
    },
    Ua = {},
    k9 = {};
  d &&
    ((k9 = document.createElement("div").style),
    "AnimationEvent" in window ||
      (delete nr.animationend.animation,
      delete nr.animationiteration.animation,
      delete nr.animationstart.animation),
    "TransitionEvent" in window || delete nr.transitionend.transition);
  function Cs(t) {
    if (Ua[t]) return Ua[t];
    if (!nr[t]) return t;
    var i = nr[t],
      s;
    for (s in i) if (i.hasOwnProperty(s) && s in k9) return (Ua[t] = i[s]);
    return t;
  }
  var S9 = Cs("animationend"),
    E9 = Cs("animationiteration"),
    P9 = Cs("animationstart"),
    z9 = Cs("transitionend"),
    O9 = new Map(),
    M9 =
      "abort auxClick cancel canPlay canPlayThrough click close contextMenu copy cut drag dragEnd dragEnter dragExit dragLeave dragOver dragStart drop durationChange emptied encrypted ended error gotPointerCapture input invalid keyDown keyPress keyUp load loadedData loadedMetadata loadStart lostPointerCapture mouseDown mouseMove mouseOut mouseOver mouseUp paste pause play playing pointerCancel pointerDown pointerMove pointerOut pointerOver pointerUp progress rateChange reset resize seeked seeking stalled submit suspend timeUpdate touchCancel touchEnd touchStart volumeChange scroll toggle touchMove waiting wheel".split(
        " ",
      );
  function qn(t, i) {
    (O9.set(t, i), u(i, [t]));
  }
  for (var Ha = 0; Ha < M9.length; Ha++) {
    var Va = M9[Ha],
      e4 = Va.toLowerCase(),
      t4 = Va[0].toUpperCase() + Va.slice(1);
    qn(e4, "on" + t4);
  }
  (qn(S9, "onAnimationEnd"),
    qn(E9, "onAnimationIteration"),
    qn(P9, "onAnimationStart"),
    qn("dblclick", "onDoubleClick"),
    qn("focusin", "onFocus"),
    qn("focusout", "onBlur"),
    qn(z9, "onTransitionEnd"),
    c("onMouseEnter", ["mouseout", "mouseover"]),
    c("onMouseLeave", ["mouseout", "mouseover"]),
    c("onPointerEnter", ["pointerout", "pointerover"]),
    c("onPointerLeave", ["pointerout", "pointerover"]),
    u(
      "onChange",
      "change click focusin focusout input keydown keyup selectionchange".split(
        " ",
      ),
    ),
    u(
      "onSelect",
      "focusout contextmenu dragend focusin keydown keyup mousedown mouseup selectionchange".split(
        " ",
      ),
    ),
    u("onBeforeInput", ["compositionend", "keypress", "textInput", "paste"]),
    u(
      "onCompositionEnd",
      "compositionend focusout keydown keypress keyup mousedown".split(" "),
    ),
    u(
      "onCompositionStart",
      "compositionstart focusout keydown keypress keyup mousedown".split(" "),
    ),
    u(
      "onCompositionUpdate",
      "compositionupdate focusout keydown keypress keyup mousedown".split(" "),
    ));
  var yo =
      "abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange resize seeked seeking stalled suspend timeupdate volumechange waiting".split(
        " ",
      ),
    n4 = new Set(
      "cancel close invalid load scroll toggle".split(" ").concat(yo),
    );
  function R9(t, i, s) {
    var a = t.type || "unknown-event";
    ((t.currentTarget = s), e5(a, i, void 0, t), (t.currentTarget = null));
  }
  function D9(t, i) {
    i = (i & 4) !== 0;
    for (var s = 0; s < t.length; s++) {
      var a = t[s],
        f = a.event;
      a = a.listeners;
      e: {
        var h = void 0;
        if (i)
          for (var y = a.length - 1; 0 <= y; y--) {
            var w = a[y],
              k = w.instance,
              M = w.currentTarget;
            if (((w = w.listener), k !== h && f.isPropagationStopped()))
              break e;
            (R9(f, w, M), (h = k));
          }
        else
          for (y = 0; y < a.length; y++) {
            if (
              ((w = a[y]),
              (k = w.instance),
              (M = w.currentTarget),
              (w = w.listener),
              k !== h && f.isPropagationStopped())
            )
              break e;
            (R9(f, w, M), (h = k));
          }
      }
    }
    if (is) throw ((t = xa), (is = !1), (xa = null), t);
  }
  function Me(t, i) {
    var s = i[Xa];
    s === void 0 && (s = i[Xa] = new Set());
    var a = t + "__bubble";
    s.has(a) || (T9(i, t, 2, !1), s.add(a));
  }
  function Wa(t, i, s) {
    var a = 0;
    (i && (a |= 4), T9(s, t, a, i));
  }
  var ws = "_reactListening" + Math.random().toString(36).slice(2);
  function go(t) {
    if (!t[ws]) {
      ((t[ws] = !0),
        o.forEach(function (s) {
          s !== "selectionchange" && (n4.has(s) || Wa(s, !1, t), Wa(s, !0, t));
        }));
      var i = t.nodeType === 9 ? t : t.ownerDocument;
      i === null || i[ws] || ((i[ws] = !0), Wa("selectionchange", !1, i));
    }
  }
  function T9(t, i, s, a) {
    switch (n9(i)) {
      case 1:
        var f = y5;
        break;
      case 4:
        f = g5;
        break;
      default:
        f = za;
    }
    ((s = f.bind(null, i, s, t)),
      (f = void 0),
      !wa ||
        (i !== "touchstart" && i !== "touchmove" && i !== "wheel") ||
        (f = !0),
      a
        ? f !== void 0
          ? t.addEventListener(i, s, { capture: !0, passive: f })
          : t.addEventListener(i, s, !0)
        : f !== void 0
          ? t.addEventListener(i, s, { passive: f })
          : t.addEventListener(i, s, !1));
  }
  function qa(t, i, s, a, f) {
    var h = a;
    if (!(i & 1) && !(i & 2) && a !== null)
      e: for (;;) {
        if (a === null) return;
        var y = a.tag;
        if (y === 3 || y === 4) {
          var w = a.stateNode.containerInfo;
          if (w === f || (w.nodeType === 8 && w.parentNode === f)) break;
          if (y === 4)
            for (y = a.return; y !== null;) {
              var k = y.tag;
              if (
                (k === 3 || k === 4) &&
                ((k = y.stateNode.containerInfo),
                k === f || (k.nodeType === 8 && k.parentNode === f))
              )
                return;
              y = y.return;
            }
          for (; w !== null;) {
            if (((y = gi(w)), y === null)) return;
            if (((k = y.tag), k === 5 || k === 6)) {
              a = h = y;
              continue e;
            }
            w = w.parentNode;
          }
        }
        a = a.return;
      }
    N3(function () {
      var M = h,
        j = ga(s),
        B = [];
      e: {
        var A = O9.get(t);
        if (A !== void 0) {
          var G = Ra,
            Z = t;
          switch (t) {
            case "keypress":
              if (ps(s) === 0) break e;
            case "keydown":
            case "keyup":
              G = D5;
              break;
            case "focusin":
              ((Z = "focus"), (G = Ia));
              break;
            case "focusout":
              ((Z = "blur"), (G = Ia));
              break;
            case "beforeblur":
            case "afterblur":
              G = Ia;
              break;
            case "click":
              if (s.button === 2) break e;
            case "auxclick":
            case "dblclick":
            case "mousedown":
            case "mousemove":
            case "mouseup":
            case "mouseout":
            case "mouseover":
            case "contextmenu":
              G = o9;
              break;
            case "drag":
            case "dragend":
            case "dragenter":
            case "dragexit":
            case "dragleave":
            case "dragover":
            case "dragstart":
            case "drop":
              G = w5;
              break;
            case "touchcancel":
            case "touchend":
            case "touchmove":
            case "touchstart":
              G = L5;
              break;
            case S9:
            case E9:
            case P9:
              G = b5;
              break;
            case z9:
              G = A5;
              break;
            case "scroll":
              G = v5;
              break;
            case "wheel":
              G = $5;
              break;
            case "copy":
            case "cut":
            case "paste":
              G = S5;
              break;
            case "gotpointercapture":
            case "lostpointercapture":
            case "pointercancel":
            case "pointerdown":
            case "pointermove":
            case "pointerout":
            case "pointerover":
            case "pointerup":
              G = l9;
          }
          var K = (i & 4) !== 0,
            He = !K && t === "scroll",
            z = K ? (A !== null ? A + "Capture" : null) : A;
          K = [];
          for (var S = M, O; S !== null;) {
            O = S;
            var U = O.stateNode;
            if (
              (O.tag === 5 &&
                U !== null &&
                ((O = U),
                z !== null &&
                  ((U = Xr(S, z)), U != null && K.push(vo(S, U, O)))),
              He)
            )
              break;
            S = S.return;
          }
          0 < K.length &&
            ((A = new G(A, Z, null, s, j)), B.push({ event: A, listeners: K }));
        }
      }
      if (!(i & 7)) {
        e: {
          if (
            ((A = t === "mouseover" || t === "pointerover"),
            (G = t === "mouseout" || t === "pointerout"),
            A &&
              s !== ya &&
              (Z = s.relatedTarget || s.fromElement) &&
              (gi(Z) || Z[zn]))
          )
            break e;
          if (
            (G || A) &&
            ((A =
              j.window === j
                ? j
                : (A = j.ownerDocument)
                  ? A.defaultView || A.parentWindow
                  : window),
            G
              ? ((Z = s.relatedTarget || s.toElement),
                (G = M),
                (Z = Z ? gi(Z) : null),
                Z !== null &&
                  ((He = yi(Z)), Z !== He || (Z.tag !== 5 && Z.tag !== 6)) &&
                  (Z = null))
              : ((G = null), (Z = M)),
            G !== Z)
          ) {
            if (
              ((K = o9),
              (U = "onMouseLeave"),
              (z = "onMouseEnter"),
              (S = "mouse"),
              (t === "pointerout" || t === "pointerover") &&
                ((K = l9),
                (U = "onPointerLeave"),
                (z = "onPointerEnter"),
                (S = "pointer")),
              (He = G == null ? A : or(G)),
              (O = Z == null ? A : or(Z)),
              (A = new K(U, S + "leave", G, s, j)),
              (A.target = He),
              (A.relatedTarget = O),
              (U = null),
              gi(j) === M &&
                ((K = new K(z, S + "enter", Z, s, j)),
                (K.target = O),
                (K.relatedTarget = He),
                (U = K)),
              (He = U),
              G && Z)
            )
              t: {
                for (K = G, z = Z, S = 0, O = K; O; O = ir(O)) S++;
                for (O = 0, U = z; U; U = ir(U)) O++;
                for (; 0 < S - O;) ((K = ir(K)), S--);
                for (; 0 < O - S;) ((z = ir(z)), O--);
                for (; S--;) {
                  if (K === z || (z !== null && K === z.alternate)) break t;
                  ((K = ir(K)), (z = ir(z)));
                }
                K = null;
              }
            else K = null;
            (G !== null && I9(B, A, G, K, !1),
              Z !== null && He !== null && I9(B, He, Z, K, !0));
          }
        }
        e: {
          if (
            ((A = M ? or(M) : window),
            (G = A.nodeName && A.nodeName.toLowerCase()),
            G === "select" || (G === "input" && A.type === "file"))
          )
            var Y = q5;
          else if (h9(A))
            if (m9) Y = K5;
            else {
              Y = Q5;
              var te = G5;
            }
          else
            (G = A.nodeName) &&
              G.toLowerCase() === "input" &&
              (A.type === "checkbox" || A.type === "radio") &&
              (Y = Z5);
          if (Y && (Y = Y(t, M))) {
            p9(B, Y, s, j);
            break e;
          }
          (te && te(t, A, M),
            t === "focusout" &&
              (te = A._wrapperState) &&
              te.controlled &&
              A.type === "number" &&
              fa(A, "number", A.value));
        }
        switch (((te = M ? or(M) : window), t)) {
          case "focusin":
            (h9(te) || te.contentEditable === "true") &&
              ((tr = te), (ja = M), (mo = null));
            break;
          case "focusout":
            mo = ja = tr = null;
            break;
          case "mousedown":
            Ba = !0;
            break;
          case "contextmenu":
          case "mouseup":
          case "dragend":
            ((Ba = !1), b9(B, s, j));
            break;
          case "selectionchange":
            if (J5) break;
          case "keydown":
          case "keyup":
            b9(B, s, j);
        }
        var ne;
        if (Fa)
          e: {
            switch (t) {
              case "compositionstart":
                var oe = "onCompositionStart";
                break e;
              case "compositionend":
                oe = "onCompositionEnd";
                break e;
              case "compositionupdate":
                oe = "onCompositionUpdate";
                break e;
            }
            oe = void 0;
          }
        else
          er
            ? f9(t, s) && (oe = "onCompositionEnd")
            : t === "keydown" &&
              s.keyCode === 229 &&
              (oe = "onCompositionStart");
        (oe &&
          (a9 &&
            s.locale !== "ko" &&
            (er || oe !== "onCompositionStart"
              ? oe === "onCompositionEnd" && er && (ne = i9())
              : ((Wn = j),
                (Ma = "value" in Wn ? Wn.value : Wn.textContent),
                (er = !0))),
          (te = xs(M, oe)),
          0 < te.length &&
            ((oe = new s9(oe, t, null, s, j)),
            B.push({ event: oe, listeners: te }),
            ne
              ? (oe.data = ne)
              : ((ne = d9(s)), ne !== null && (oe.data = ne)))),
          (ne = B5 ? U5(t, s) : H5(t, s)) &&
            ((M = xs(M, "onBeforeInput")),
            0 < M.length &&
              ((j = new s9("onBeforeInput", "beforeinput", null, s, j)),
              B.push({ event: j, listeners: M }),
              (j.data = ne))));
      }
      D9(B, i);
    });
  }
  function vo(t, i, s) {
    return { instance: t, listener: i, currentTarget: s };
  }
  function xs(t, i) {
    for (var s = i + "Capture", a = []; t !== null;) {
      var f = t,
        h = f.stateNode;
      (f.tag === 5 &&
        h !== null &&
        ((f = h),
        (h = Xr(t, s)),
        h != null && a.unshift(vo(t, h, f)),
        (h = Xr(t, i)),
        h != null && a.push(vo(t, h, f))),
        (t = t.return));
    }
    return a;
  }
  function ir(t) {
    if (t === null) return null;
    do t = t.return;
    while (t && t.tag !== 5);
    return t || null;
  }
  function I9(t, i, s, a, f) {
    for (var h = i._reactName, y = []; s !== null && s !== a;) {
      var w = s,
        k = w.alternate,
        M = w.stateNode;
      if (k !== null && k === a) break;
      (w.tag === 5 &&
        M !== null &&
        ((w = M),
        f
          ? ((k = Xr(s, h)), k != null && y.unshift(vo(s, k, w)))
          : f || ((k = Xr(s, h)), k != null && y.push(vo(s, k, w)))),
        (s = s.return));
    }
    y.length !== 0 && t.push({ event: i, listeners: y });
  }
  var i4 = /\r\n?/g,
    r4 = /\u0000|\uFFFD/g;
  function L9(t) {
    return (typeof t == "string" ? t : "" + t)
      .replace(
        i4,
        `
`,
      )
      .replace(r4, "");
  }
  function _s(t, i, s) {
    if (((i = L9(i)), L9(t) !== i && s)) throw Error(r(425));
  }
  function bs() {}
  var Ga = null,
    Qa = null;
  function Za(t, i) {
    return (
      t === "textarea" ||
      t === "noscript" ||
      typeof i.children == "string" ||
      typeof i.children == "number" ||
      (typeof i.dangerouslySetInnerHTML == "object" &&
        i.dangerouslySetInnerHTML !== null &&
        i.dangerouslySetInnerHTML.__html != null)
    );
  }
  var Ka = typeof setTimeout == "function" ? setTimeout : void 0,
    o4 = typeof clearTimeout == "function" ? clearTimeout : void 0,
    F9 = typeof Promise == "function" ? Promise : void 0,
    s4 =
      typeof queueMicrotask == "function"
        ? queueMicrotask
        : typeof F9 < "u"
          ? function (t) {
              return F9.resolve(null).then(t).catch(l4);
            }
          : Ka;
  function l4(t) {
    setTimeout(function () {
      throw t;
    });
  }
  function Ya(t, i) {
    var s = i,
      a = 0;
    do {
      var f = s.nextSibling;
      if ((t.removeChild(s), f && f.nodeType === 8))
        if (((s = f.data), s === "/$")) {
          if (a === 0) {
            (t.removeChild(f), lo(i));
            return;
          }
          a--;
        } else (s !== "$" && s !== "$?" && s !== "$!") || a++;
      s = f;
    } while (s);
    lo(i);
  }
  function Gn(t) {
    for (; t != null; t = t.nextSibling) {
      var i = t.nodeType;
      if (i === 1 || i === 3) break;
      if (i === 8) {
        if (((i = t.data), i === "$" || i === "$!" || i === "$?")) break;
        if (i === "/$") return null;
      }
    }
    return t;
  }
  function A9(t) {
    t = t.previousSibling;
    for (var i = 0; t;) {
      if (t.nodeType === 8) {
        var s = t.data;
        if (s === "$" || s === "$!" || s === "$?") {
          if (i === 0) return t;
          i--;
        } else s === "/$" && i++;
      }
      t = t.previousSibling;
    }
    return null;
  }
  var rr = Math.random().toString(36).slice(2),
    yn = "__reactFiber$" + rr,
    Co = "__reactProps$" + rr,
    zn = "__reactContainer$" + rr,
    Xa = "__reactEvents$" + rr,
    a4 = "__reactListeners$" + rr,
    u4 = "__reactHandles$" + rr;
  function gi(t) {
    var i = t[yn];
    if (i) return i;
    for (var s = t.parentNode; s;) {
      if ((i = s[zn] || s[yn])) {
        if (
          ((s = i.alternate),
          i.child !== null || (s !== null && s.child !== null))
        )
          for (t = A9(t); t !== null;) {
            if ((s = t[yn])) return s;
            t = A9(t);
          }
        return i;
      }
      ((t = s), (s = t.parentNode));
    }
    return null;
  }
  function wo(t) {
    return (
      (t = t[yn] || t[zn]),
      !t || (t.tag !== 5 && t.tag !== 6 && t.tag !== 13 && t.tag !== 3)
        ? null
        : t
    );
  }
  function or(t) {
    if (t.tag === 5 || t.tag === 6) return t.stateNode;
    throw Error(r(33));
  }
  function ks(t) {
    return t[Co] || null;
  }
  var Ja = [],
    sr = -1;
  function Qn(t) {
    return { current: t };
  }
  function Re(t) {
    0 > sr || ((t.current = Ja[sr]), (Ja[sr] = null), sr--);
  }
  function Pe(t, i) {
    (sr++, (Ja[sr] = t.current), (t.current = i));
  }
  var Zn = {},
    dt = Qn(Zn),
    St = Qn(!1),
    vi = Zn;
  function lr(t, i) {
    var s = t.type.contextTypes;
    if (!s) return Zn;
    var a = t.stateNode;
    if (a && a.__reactInternalMemoizedUnmaskedChildContext === i)
      return a.__reactInternalMemoizedMaskedChildContext;
    var f = {},
      h;
    for (h in s) f[h] = i[h];
    return (
      a &&
        ((t = t.stateNode),
        (t.__reactInternalMemoizedUnmaskedChildContext = i),
        (t.__reactInternalMemoizedMaskedChildContext = f)),
      f
    );
  }
  function Et(t) {
    return ((t = t.childContextTypes), t != null);
  }
  function Ss() {
    (Re(St), Re(dt));
  }
  function N9(t, i, s) {
    if (dt.current !== Zn) throw Error(r(168));
    (Pe(dt, i), Pe(St, s));
  }
  function $9(t, i, s) {
    var a = t.stateNode;
    if (((i = i.childContextTypes), typeof a.getChildContext != "function"))
      return s;
    a = a.getChildContext();
    for (var f in a) if (!(f in i)) throw Error(r(108, xe(t) || "Unknown", f));
    return q({}, s, a);
  }
  function Es(t) {
    return (
      (t =
        ((t = t.stateNode) && t.__reactInternalMemoizedMergedChildContext) ||
        Zn),
      (vi = dt.current),
      Pe(dt, t),
      Pe(St, St.current),
      !0
    );
  }
  function j9(t, i, s) {
    var a = t.stateNode;
    if (!a) throw Error(r(169));
    (s
      ? ((t = $9(t, i, vi)),
        (a.__reactInternalMemoizedMergedChildContext = t),
        Re(St),
        Re(dt),
        Pe(dt, t))
      : Re(St),
      Pe(St, s));
  }
  var On = null,
    Ps = !1,
    eu = !1;
  function B9(t) {
    On === null ? (On = [t]) : On.push(t);
  }
  function c4(t) {
    ((Ps = !0), B9(t));
  }
  function Kn() {
    if (!eu && On !== null) {
      eu = !0;
      var t = 0,
        i = ke;
      try {
        var s = On;
        for (ke = 1; t < s.length; t++) {
          var a = s[t];
          do a = a(!0);
          while (a !== null);
        }
        ((On = null), (Ps = !1));
      } catch (f) {
        throw (On !== null && (On = On.slice(t + 1)), H3(_a, Kn), f);
      } finally {
        ((ke = i), (eu = !1));
      }
    }
    return null;
  }
  var ar = [],
    ur = 0,
    zs = null,
    Os = 0,
    Bt = [],
    Ut = 0,
    Ci = null,
    Mn = 1,
    Rn = "";
  function wi(t, i) {
    ((ar[ur++] = Os), (ar[ur++] = zs), (zs = t), (Os = i));
  }
  function U9(t, i, s) {
    ((Bt[Ut++] = Mn), (Bt[Ut++] = Rn), (Bt[Ut++] = Ci), (Ci = t));
    var a = Mn;
    t = Rn;
    var f = 32 - Jt(a) - 1;
    ((a &= ~(1 << f)), (s += 1));
    var h = 32 - Jt(i) + f;
    if (30 < h) {
      var y = f - (f % 5);
      ((h = (a & ((1 << y) - 1)).toString(32)),
        (a >>= y),
        (f -= y),
        (Mn = (1 << (32 - Jt(i) + f)) | (s << f) | a),
        (Rn = h + t));
    } else ((Mn = (1 << h) | (s << f) | a), (Rn = t));
  }
  function tu(t) {
    t.return !== null && (wi(t, 1), U9(t, 1, 0));
  }
  function nu(t) {
    for (; t === zs;)
      ((zs = ar[--ur]), (ar[ur] = null), (Os = ar[--ur]), (ar[ur] = null));
    for (; t === Ci;)
      ((Ci = Bt[--Ut]),
        (Bt[Ut] = null),
        (Rn = Bt[--Ut]),
        (Bt[Ut] = null),
        (Mn = Bt[--Ut]),
        (Bt[Ut] = null));
  }
  var Tt = null,
    It = null,
    Te = !1,
    tn = null;
  function H9(t, i) {
    var s = qt(5, null, null, 0);
    ((s.elementType = "DELETED"),
      (s.stateNode = i),
      (s.return = t),
      (i = t.deletions),
      i === null ? ((t.deletions = [s]), (t.flags |= 16)) : i.push(s));
  }
  function V9(t, i) {
    switch (t.tag) {
      case 5:
        var s = t.type;
        return (
          (i =
            i.nodeType !== 1 || s.toLowerCase() !== i.nodeName.toLowerCase()
              ? null
              : i),
          i !== null
            ? ((t.stateNode = i), (Tt = t), (It = Gn(i.firstChild)), !0)
            : !1
        );
      case 6:
        return (
          (i = t.pendingProps === "" || i.nodeType !== 3 ? null : i),
          i !== null ? ((t.stateNode = i), (Tt = t), (It = null), !0) : !1
        );
      case 13:
        return (
          (i = i.nodeType !== 8 ? null : i),
          i !== null
            ? ((s = Ci !== null ? { id: Mn, overflow: Rn } : null),
              (t.memoizedState = {
                dehydrated: i,
                treeContext: s,
                retryLane: 1073741824,
              }),
              (s = qt(18, null, null, 0)),
              (s.stateNode = i),
              (s.return = t),
              (t.child = s),
              (Tt = t),
              (It = null),
              !0)
            : !1
        );
      default:
        return !1;
    }
  }
  function iu(t) {
    return (t.mode & 1) !== 0 && (t.flags & 128) === 0;
  }
  function ru(t) {
    if (Te) {
      var i = It;
      if (i) {
        var s = i;
        if (!V9(t, i)) {
          if (iu(t)) throw Error(r(418));
          i = Gn(s.nextSibling);
          var a = Tt;
          i && V9(t, i)
            ? H9(a, s)
            : ((t.flags = (t.flags & -4097) | 2), (Te = !1), (Tt = t));
        }
      } else {
        if (iu(t)) throw Error(r(418));
        ((t.flags = (t.flags & -4097) | 2), (Te = !1), (Tt = t));
      }
    }
  }
  function W9(t) {
    for (
      t = t.return;
      t !== null && t.tag !== 5 && t.tag !== 3 && t.tag !== 13;
    )
      t = t.return;
    Tt = t;
  }
  function Ms(t) {
    if (t !== Tt) return !1;
    if (!Te) return (W9(t), (Te = !0), !1);
    var i;
    if (
      ((i = t.tag !== 3) &&
        !(i = t.tag !== 5) &&
        ((i = t.type),
        (i = i !== "head" && i !== "body" && !Za(t.type, t.memoizedProps))),
      i && (i = It))
    ) {
      if (iu(t)) throw (q9(), Error(r(418)));
      for (; i;) (H9(t, i), (i = Gn(i.nextSibling)));
    }
    if ((W9(t), t.tag === 13)) {
      if (((t = t.memoizedState), (t = t !== null ? t.dehydrated : null), !t))
        throw Error(r(317));
      e: {
        for (t = t.nextSibling, i = 0; t;) {
          if (t.nodeType === 8) {
            var s = t.data;
            if (s === "/$") {
              if (i === 0) {
                It = Gn(t.nextSibling);
                break e;
              }
              i--;
            } else (s !== "$" && s !== "$!" && s !== "$?") || i++;
          }
          t = t.nextSibling;
        }
        It = null;
      }
    } else It = Tt ? Gn(t.stateNode.nextSibling) : null;
    return !0;
  }
  function q9() {
    for (var t = It; t;) t = Gn(t.nextSibling);
  }
  function cr() {
    ((It = Tt = null), (Te = !1));
  }
  function ou(t) {
    tn === null ? (tn = [t]) : tn.push(t);
  }
  var f4 = R.ReactCurrentBatchConfig;
  function xo(t, i, s) {
    if (
      ((t = s.ref),
      t !== null && typeof t != "function" && typeof t != "object")
    ) {
      if (s._owner) {
        if (((s = s._owner), s)) {
          if (s.tag !== 1) throw Error(r(309));
          var a = s.stateNode;
        }
        if (!a) throw Error(r(147, t));
        var f = a,
          h = "" + t;
        return i !== null &&
          i.ref !== null &&
          typeof i.ref == "function" &&
          i.ref._stringRef === h
          ? i.ref
          : ((i = function (y) {
              var w = f.refs;
              y === null ? delete w[h] : (w[h] = y);
            }),
            (i._stringRef = h),
            i);
      }
      if (typeof t != "string") throw Error(r(284));
      if (!s._owner) throw Error(r(290, t));
    }
    return t;
  }
  function Rs(t, i) {
    throw (
      (t = Object.prototype.toString.call(i)),
      Error(
        r(
          31,
          t === "[object Object]"
            ? "object with keys {" + Object.keys(i).join(", ") + "}"
            : t,
        ),
      )
    );
  }
  function G9(t) {
    var i = t._init;
    return i(t._payload);
  }
  function Q9(t) {
    function i(z, S) {
      if (t) {
        var O = z.deletions;
        O === null ? ((z.deletions = [S]), (z.flags |= 16)) : O.push(S);
      }
    }
    function s(z, S) {
      if (!t) return null;
      for (; S !== null;) (i(z, S), (S = S.sibling));
      return null;
    }
    function a(z, S) {
      for (z = new Map(); S !== null;)
        (S.key !== null ? z.set(S.key, S) : z.set(S.index, S), (S = S.sibling));
      return z;
    }
    function f(z, S) {
      return ((z = ri(z, S)), (z.index = 0), (z.sibling = null), z);
    }
    function h(z, S, O) {
      return (
        (z.index = O),
        t
          ? ((O = z.alternate),
            O !== null
              ? ((O = O.index), O < S ? ((z.flags |= 2), S) : O)
              : ((z.flags |= 2), S))
          : ((z.flags |= 1048576), S)
      );
    }
    function y(z) {
      return (t && z.alternate === null && (z.flags |= 2), z);
    }
    function w(z, S, O, U) {
      return S === null || S.tag !== 6
        ? ((S = Ku(O, z.mode, U)), (S.return = z), S)
        : ((S = f(S, O)), (S.return = z), S);
    }
    function k(z, S, O, U) {
      var Y = O.type;
      return Y === V
        ? j(z, S, O.props.children, U, O.key)
        : S !== null &&
            (S.elementType === Y ||
              (typeof Y == "object" &&
                Y !== null &&
                Y.$$typeof === ft &&
                G9(Y) === S.type))
          ? ((U = f(S, O.props)), (U.ref = xo(z, S, O)), (U.return = z), U)
          : ((U = tl(O.type, O.key, O.props, null, z.mode, U)),
            (U.ref = xo(z, S, O)),
            (U.return = z),
            U);
    }
    function M(z, S, O, U) {
      return S === null ||
        S.tag !== 4 ||
        S.stateNode.containerInfo !== O.containerInfo ||
        S.stateNode.implementation !== O.implementation
        ? ((S = Yu(O, z.mode, U)), (S.return = z), S)
        : ((S = f(S, O.children || [])), (S.return = z), S);
    }
    function j(z, S, O, U, Y) {
      return S === null || S.tag !== 7
        ? ((S = zi(O, z.mode, U, Y)), (S.return = z), S)
        : ((S = f(S, O)), (S.return = z), S);
    }
    function B(z, S, O) {
      if ((typeof S == "string" && S !== "") || typeof S == "number")
        return ((S = Ku("" + S, z.mode, O)), (S.return = z), S);
      if (typeof S == "object" && S !== null) {
        switch (S.$$typeof) {
          case N:
            return (
              (O = tl(S.type, S.key, S.props, null, z.mode, O)),
              (O.ref = xo(z, null, S)),
              (O.return = z),
              O
            );
          case F:
            return ((S = Yu(S, z.mode, O)), (S.return = z), S);
          case ft:
            var U = S._init;
            return B(z, U(S._payload), O);
        }
        if (Zr(S) || X(S))
          return ((S = zi(S, z.mode, O, null)), (S.return = z), S);
        Rs(z, S);
      }
      return null;
    }
    function A(z, S, O, U) {
      var Y = S !== null ? S.key : null;
      if ((typeof O == "string" && O !== "") || typeof O == "number")
        return Y !== null ? null : w(z, S, "" + O, U);
      if (typeof O == "object" && O !== null) {
        switch (O.$$typeof) {
          case N:
            return O.key === Y ? k(z, S, O, U) : null;
          case F:
            return O.key === Y ? M(z, S, O, U) : null;
          case ft:
            return ((Y = O._init), A(z, S, Y(O._payload), U));
        }
        if (Zr(O) || X(O)) return Y !== null ? null : j(z, S, O, U, null);
        Rs(z, O);
      }
      return null;
    }
    function G(z, S, O, U, Y) {
      if ((typeof U == "string" && U !== "") || typeof U == "number")
        return ((z = z.get(O) || null), w(S, z, "" + U, Y));
      if (typeof U == "object" && U !== null) {
        switch (U.$$typeof) {
          case N:
            return (
              (z = z.get(U.key === null ? O : U.key) || null),
              k(S, z, U, Y)
            );
          case F:
            return (
              (z = z.get(U.key === null ? O : U.key) || null),
              M(S, z, U, Y)
            );
          case ft:
            var te = U._init;
            return G(z, S, O, te(U._payload), Y);
        }
        if (Zr(U) || X(U)) return ((z = z.get(O) || null), j(S, z, U, Y, null));
        Rs(S, U);
      }
      return null;
    }
    function Z(z, S, O, U) {
      for (
        var Y = null, te = null, ne = S, oe = (S = 0), tt = null;
        ne !== null && oe < O.length;
        oe++
      ) {
        ne.index > oe ? ((tt = ne), (ne = null)) : (tt = ne.sibling);
        var we = A(z, ne, O[oe], U);
        if (we === null) {
          ne === null && (ne = tt);
          break;
        }
        (t && ne && we.alternate === null && i(z, ne),
          (S = h(we, S, oe)),
          te === null ? (Y = we) : (te.sibling = we),
          (te = we),
          (ne = tt));
      }
      if (oe === O.length) return (s(z, ne), Te && wi(z, oe), Y);
      if (ne === null) {
        for (; oe < O.length; oe++)
          ((ne = B(z, O[oe], U)),
            ne !== null &&
              ((S = h(ne, S, oe)),
              te === null ? (Y = ne) : (te.sibling = ne),
              (te = ne)));
        return (Te && wi(z, oe), Y);
      }
      for (ne = a(z, ne); oe < O.length; oe++)
        ((tt = G(ne, z, oe, O[oe], U)),
          tt !== null &&
            (t &&
              tt.alternate !== null &&
              ne.delete(tt.key === null ? oe : tt.key),
            (S = h(tt, S, oe)),
            te === null ? (Y = tt) : (te.sibling = tt),
            (te = tt)));
      return (
        t &&
          ne.forEach(function (oi) {
            return i(z, oi);
          }),
        Te && wi(z, oe),
        Y
      );
    }
    function K(z, S, O, U) {
      var Y = X(O);
      if (typeof Y != "function") throw Error(r(150));
      if (((O = Y.call(O)), O == null)) throw Error(r(151));
      for (
        var te = (Y = null), ne = S, oe = (S = 0), tt = null, we = O.next();
        ne !== null && !we.done;
        oe++, we = O.next()
      ) {
        ne.index > oe ? ((tt = ne), (ne = null)) : (tt = ne.sibling);
        var oi = A(z, ne, we.value, U);
        if (oi === null) {
          ne === null && (ne = tt);
          break;
        }
        (t && ne && oi.alternate === null && i(z, ne),
          (S = h(oi, S, oe)),
          te === null ? (Y = oi) : (te.sibling = oi),
          (te = oi),
          (ne = tt));
      }
      if (we.done) return (s(z, ne), Te && wi(z, oe), Y);
      if (ne === null) {
        for (; !we.done; oe++, we = O.next())
          ((we = B(z, we.value, U)),
            we !== null &&
              ((S = h(we, S, oe)),
              te === null ? (Y = we) : (te.sibling = we),
              (te = we)));
        return (Te && wi(z, oe), Y);
      }
      for (ne = a(z, ne); !we.done; oe++, we = O.next())
        ((we = G(ne, z, oe, we.value, U)),
          we !== null &&
            (t &&
              we.alternate !== null &&
              ne.delete(we.key === null ? oe : we.key),
            (S = h(we, S, oe)),
            te === null ? (Y = we) : (te.sibling = we),
            (te = we)));
      return (
        t &&
          ne.forEach(function (V4) {
            return i(z, V4);
          }),
        Te && wi(z, oe),
        Y
      );
    }
    function He(z, S, O, U) {
      if (
        (typeof O == "object" &&
          O !== null &&
          O.type === V &&
          O.key === null &&
          (O = O.props.children),
        typeof O == "object" && O !== null)
      ) {
        switch (O.$$typeof) {
          case N:
            e: {
              for (var Y = O.key, te = S; te !== null;) {
                if (te.key === Y) {
                  if (((Y = O.type), Y === V)) {
                    if (te.tag === 7) {
                      (s(z, te.sibling),
                        (S = f(te, O.props.children)),
                        (S.return = z),
                        (z = S));
                      break e;
                    }
                  } else if (
                    te.elementType === Y ||
                    (typeof Y == "object" &&
                      Y !== null &&
                      Y.$$typeof === ft &&
                      G9(Y) === te.type)
                  ) {
                    (s(z, te.sibling),
                      (S = f(te, O.props)),
                      (S.ref = xo(z, te, O)),
                      (S.return = z),
                      (z = S));
                    break e;
                  }
                  s(z, te);
                  break;
                } else i(z, te);
                te = te.sibling;
              }
              O.type === V
                ? ((S = zi(O.props.children, z.mode, U, O.key)),
                  (S.return = z),
                  (z = S))
                : ((U = tl(O.type, O.key, O.props, null, z.mode, U)),
                  (U.ref = xo(z, S, O)),
                  (U.return = z),
                  (z = U));
            }
            return y(z);
          case F:
            e: {
              for (te = O.key; S !== null;) {
                if (S.key === te)
                  if (
                    S.tag === 4 &&
                    S.stateNode.containerInfo === O.containerInfo &&
                    S.stateNode.implementation === O.implementation
                  ) {
                    (s(z, S.sibling),
                      (S = f(S, O.children || [])),
                      (S.return = z),
                      (z = S));
                    break e;
                  } else {
                    s(z, S);
                    break;
                  }
                else i(z, S);
                S = S.sibling;
              }
              ((S = Yu(O, z.mode, U)), (S.return = z), (z = S));
            }
            return y(z);
          case ft:
            return ((te = O._init), He(z, S, te(O._payload), U));
        }
        if (Zr(O)) return Z(z, S, O, U);
        if (X(O)) return K(z, S, O, U);
        Rs(z, O);
      }
      return (typeof O == "string" && O !== "") || typeof O == "number"
        ? ((O = "" + O),
          S !== null && S.tag === 6
            ? (s(z, S.sibling), (S = f(S, O)), (S.return = z), (z = S))
            : (s(z, S), (S = Ku(O, z.mode, U)), (S.return = z), (z = S)),
          y(z))
        : s(z, S);
    }
    return He;
  }
  var fr = Q9(!0),
    Z9 = Q9(!1),
    Ds = Qn(null),
    Ts = null,
    dr = null,
    su = null;
  function lu() {
    su = dr = Ts = null;
  }
  function au(t) {
    var i = Ds.current;
    (Re(Ds), (t._currentValue = i));
  }
  function uu(t, i, s) {
    for (; t !== null;) {
      var a = t.alternate;
      if (
        ((t.childLanes & i) !== i
          ? ((t.childLanes |= i), a !== null && (a.childLanes |= i))
          : a !== null && (a.childLanes & i) !== i && (a.childLanes |= i),
        t === s)
      )
        break;
      t = t.return;
    }
  }
  function hr(t, i) {
    ((Ts = t),
      (su = dr = null),
      (t = t.dependencies),
      t !== null &&
        t.firstContext !== null &&
        (t.lanes & i && (Pt = !0), (t.firstContext = null)));
  }
  function Ht(t) {
    var i = t._currentValue;
    if (su !== t)
      if (((t = { context: t, memoizedValue: i, next: null }), dr === null)) {
        if (Ts === null) throw Error(r(308));
        ((dr = t), (Ts.dependencies = { lanes: 0, firstContext: t }));
      } else dr = dr.next = t;
    return i;
  }
  var xi = null;
  function cu(t) {
    xi === null ? (xi = [t]) : xi.push(t);
  }
  function K9(t, i, s, a) {
    var f = i.interleaved;
    return (
      f === null ? ((s.next = s), cu(i)) : ((s.next = f.next), (f.next = s)),
      (i.interleaved = s),
      Dn(t, a)
    );
  }
  function Dn(t, i) {
    t.lanes |= i;
    var s = t.alternate;
    for (s !== null && (s.lanes |= i), s = t, t = t.return; t !== null;)
      ((t.childLanes |= i),
        (s = t.alternate),
        s !== null && (s.childLanes |= i),
        (s = t),
        (t = t.return));
    return s.tag === 3 ? s.stateNode : null;
  }
  var Yn = !1;
  function fu(t) {
    t.updateQueue = {
      baseState: t.memoizedState,
      firstBaseUpdate: null,
      lastBaseUpdate: null,
      shared: { pending: null, interleaved: null, lanes: 0 },
      effects: null,
    };
  }
  function Y9(t, i) {
    ((t = t.updateQueue),
      i.updateQueue === t &&
        (i.updateQueue = {
          baseState: t.baseState,
          firstBaseUpdate: t.firstBaseUpdate,
          lastBaseUpdate: t.lastBaseUpdate,
          shared: t.shared,
          effects: t.effects,
        }));
  }
  function Tn(t, i) {
    return {
      eventTime: t,
      lane: i,
      tag: 0,
      payload: null,
      callback: null,
      next: null,
    };
  }
  function Xn(t, i, s) {
    var a = t.updateQueue;
    if (a === null) return null;
    if (((a = a.shared), ge & 2)) {
      var f = a.pending;
      return (
        f === null ? (i.next = i) : ((i.next = f.next), (f.next = i)),
        (a.pending = i),
        Dn(t, s)
      );
    }
    return (
      (f = a.interleaved),
      f === null ? ((i.next = i), cu(a)) : ((i.next = f.next), (f.next = i)),
      (a.interleaved = i),
      Dn(t, s)
    );
  }
  function Is(t, i, s) {
    if (
      ((i = i.updateQueue), i !== null && ((i = i.shared), (s & 4194240) !== 0))
    ) {
      var a = i.lanes;
      ((a &= t.pendingLanes), (s |= a), (i.lanes = s), Sa(t, s));
    }
  }
  function X9(t, i) {
    var s = t.updateQueue,
      a = t.alternate;
    if (a !== null && ((a = a.updateQueue), s === a)) {
      var f = null,
        h = null;
      if (((s = s.firstBaseUpdate), s !== null)) {
        do {
          var y = {
            eventTime: s.eventTime,
            lane: s.lane,
            tag: s.tag,
            payload: s.payload,
            callback: s.callback,
            next: null,
          };
          (h === null ? (f = h = y) : (h = h.next = y), (s = s.next));
        } while (s !== null);
        h === null ? (f = h = i) : (h = h.next = i);
      } else f = h = i;
      ((s = {
        baseState: a.baseState,
        firstBaseUpdate: f,
        lastBaseUpdate: h,
        shared: a.shared,
        effects: a.effects,
      }),
        (t.updateQueue = s));
      return;
    }
    ((t = s.lastBaseUpdate),
      t === null ? (s.firstBaseUpdate = i) : (t.next = i),
      (s.lastBaseUpdate = i));
  }
  function Ls(t, i, s, a) {
    var f = t.updateQueue;
    Yn = !1;
    var h = f.firstBaseUpdate,
      y = f.lastBaseUpdate,
      w = f.shared.pending;
    if (w !== null) {
      f.shared.pending = null;
      var k = w,
        M = k.next;
      ((k.next = null), y === null ? (h = M) : (y.next = M), (y = k));
      var j = t.alternate;
      j !== null &&
        ((j = j.updateQueue),
        (w = j.lastBaseUpdate),
        w !== y &&
          (w === null ? (j.firstBaseUpdate = M) : (w.next = M),
          (j.lastBaseUpdate = k)));
    }
    if (h !== null) {
      var B = f.baseState;
      ((y = 0), (j = M = k = null), (w = h));
      do {
        var A = w.lane,
          G = w.eventTime;
        if ((a & A) === A) {
          j !== null &&
            (j = j.next =
              {
                eventTime: G,
                lane: 0,
                tag: w.tag,
                payload: w.payload,
                callback: w.callback,
                next: null,
              });
          e: {
            var Z = t,
              K = w;
            switch (((A = i), (G = s), K.tag)) {
              case 1:
                if (((Z = K.payload), typeof Z == "function")) {
                  B = Z.call(G, B, A);
                  break e;
                }
                B = Z;
                break e;
              case 3:
                Z.flags = (Z.flags & -65537) | 128;
              case 0:
                if (
                  ((Z = K.payload),
                  (A = typeof Z == "function" ? Z.call(G, B, A) : Z),
                  A == null)
                )
                  break e;
                B = q({}, B, A);
                break e;
              case 2:
                Yn = !0;
            }
          }
          w.callback !== null &&
            w.lane !== 0 &&
            ((t.flags |= 64),
            (A = f.effects),
            A === null ? (f.effects = [w]) : A.push(w));
        } else
          ((G = {
            eventTime: G,
            lane: A,
            tag: w.tag,
            payload: w.payload,
            callback: w.callback,
            next: null,
          }),
            j === null ? ((M = j = G), (k = B)) : (j = j.next = G),
            (y |= A));
        if (((w = w.next), w === null)) {
          if (((w = f.shared.pending), w === null)) break;
          ((A = w),
            (w = A.next),
            (A.next = null),
            (f.lastBaseUpdate = A),
            (f.shared.pending = null));
        }
      } while (!0);
      if (
        (j === null && (k = B),
        (f.baseState = k),
        (f.firstBaseUpdate = M),
        (f.lastBaseUpdate = j),
        (i = f.shared.interleaved),
        i !== null)
      ) {
        f = i;
        do ((y |= f.lane), (f = f.next));
        while (f !== i);
      } else h === null && (f.shared.lanes = 0);
      ((ki |= y), (t.lanes = y), (t.memoizedState = B));
    }
  }
  function J9(t, i, s) {
    if (((t = i.effects), (i.effects = null), t !== null))
      for (i = 0; i < t.length; i++) {
        var a = t[i],
          f = a.callback;
        if (f !== null) {
          if (((a.callback = null), (a = s), typeof f != "function"))
            throw Error(r(191, f));
          f.call(a);
        }
      }
  }
  var _o = {},
    gn = Qn(_o),
    bo = Qn(_o),
    ko = Qn(_o);
  function _i(t) {
    if (t === _o) throw Error(r(174));
    return t;
  }
  function du(t, i) {
    switch ((Pe(ko, i), Pe(bo, t), Pe(gn, _o), (t = i.nodeType), t)) {
      case 9:
      case 11:
        i = (i = i.documentElement) ? i.namespaceURI : ha(null, "");
        break;
      default:
        ((t = t === 8 ? i.parentNode : i),
          (i = t.namespaceURI || null),
          (t = t.tagName),
          (i = ha(i, t)));
    }
    (Re(gn), Pe(gn, i));
  }
  function pr() {
    (Re(gn), Re(bo), Re(ko));
  }
  function ef(t) {
    _i(ko.current);
    var i = _i(gn.current),
      s = ha(i, t.type);
    i !== s && (Pe(bo, t), Pe(gn, s));
  }
  function hu(t) {
    bo.current === t && (Re(gn), Re(bo));
  }
  var Ie = Qn(0);
  function Fs(t) {
    for (var i = t; i !== null;) {
      if (i.tag === 13) {
        var s = i.memoizedState;
        if (
          s !== null &&
          ((s = s.dehydrated), s === null || s.data === "$?" || s.data === "$!")
        )
          return i;
      } else if (i.tag === 19 && i.memoizedProps.revealOrder !== void 0) {
        if (i.flags & 128) return i;
      } else if (i.child !== null) {
        ((i.child.return = i), (i = i.child));
        continue;
      }
      if (i === t) break;
      for (; i.sibling === null;) {
        if (i.return === null || i.return === t) return null;
        i = i.return;
      }
      ((i.sibling.return = i.return), (i = i.sibling));
    }
    return null;
  }
  var pu = [];
  function mu() {
    for (var t = 0; t < pu.length; t++)
      pu[t]._workInProgressVersionPrimary = null;
    pu.length = 0;
  }
  var As = R.ReactCurrentDispatcher,
    yu = R.ReactCurrentBatchConfig,
    bi = 0,
    Le = null,
    Ye = null,
    Je = null,
    Ns = !1,
    So = !1,
    Eo = 0,
    d4 = 0;
  function ht() {
    throw Error(r(321));
  }
  function gu(t, i) {
    if (i === null) return !1;
    for (var s = 0; s < i.length && s < t.length; s++)
      if (!en(t[s], i[s])) return !1;
    return !0;
  }
  function vu(t, i, s, a, f, h) {
    if (
      ((bi = h),
      (Le = i),
      (i.memoizedState = null),
      (i.updateQueue = null),
      (i.lanes = 0),
      (As.current = t === null || t.memoizedState === null ? y4 : g4),
      (t = s(a, f)),
      So)
    ) {
      h = 0;
      do {
        if (((So = !1), (Eo = 0), 25 <= h)) throw Error(r(301));
        ((h += 1),
          (Je = Ye = null),
          (i.updateQueue = null),
          (As.current = v4),
          (t = s(a, f)));
      } while (So);
    }
    if (
      ((As.current = Bs),
      (i = Ye !== null && Ye.next !== null),
      (bi = 0),
      (Je = Ye = Le = null),
      (Ns = !1),
      i)
    )
      throw Error(r(300));
    return t;
  }
  function Cu() {
    var t = Eo !== 0;
    return ((Eo = 0), t);
  }
  function vn() {
    var t = {
      memoizedState: null,
      baseState: null,
      baseQueue: null,
      queue: null,
      next: null,
    };
    return (Je === null ? (Le.memoizedState = Je = t) : (Je = Je.next = t), Je);
  }
  function Vt() {
    if (Ye === null) {
      var t = Le.alternate;
      t = t !== null ? t.memoizedState : null;
    } else t = Ye.next;
    var i = Je === null ? Le.memoizedState : Je.next;
    if (i !== null) ((Je = i), (Ye = t));
    else {
      if (t === null) throw Error(r(310));
      ((Ye = t),
        (t = {
          memoizedState: Ye.memoizedState,
          baseState: Ye.baseState,
          baseQueue: Ye.baseQueue,
          queue: Ye.queue,
          next: null,
        }),
        Je === null ? (Le.memoizedState = Je = t) : (Je = Je.next = t));
    }
    return Je;
  }
  function Po(t, i) {
    return typeof i == "function" ? i(t) : i;
  }
  function wu(t) {
    var i = Vt(),
      s = i.queue;
    if (s === null) throw Error(r(311));
    s.lastRenderedReducer = t;
    var a = Ye,
      f = a.baseQueue,
      h = s.pending;
    if (h !== null) {
      if (f !== null) {
        var y = f.next;
        ((f.next = h.next), (h.next = y));
      }
      ((a.baseQueue = f = h), (s.pending = null));
    }
    if (f !== null) {
      ((h = f.next), (a = a.baseState));
      var w = (y = null),
        k = null,
        M = h;
      do {
        var j = M.lane;
        if ((bi & j) === j)
          (k !== null &&
            (k = k.next =
              {
                lane: 0,
                action: M.action,
                hasEagerState: M.hasEagerState,
                eagerState: M.eagerState,
                next: null,
              }),
            (a = M.hasEagerState ? M.eagerState : t(a, M.action)));
        else {
          var B = {
            lane: j,
            action: M.action,
            hasEagerState: M.hasEagerState,
            eagerState: M.eagerState,
            next: null,
          };
          (k === null ? ((w = k = B), (y = a)) : (k = k.next = B),
            (Le.lanes |= j),
            (ki |= j));
        }
        M = M.next;
      } while (M !== null && M !== h);
      (k === null ? (y = a) : (k.next = w),
        en(a, i.memoizedState) || (Pt = !0),
        (i.memoizedState = a),
        (i.baseState = y),
        (i.baseQueue = k),
        (s.lastRenderedState = a));
    }
    if (((t = s.interleaved), t !== null)) {
      f = t;
      do ((h = f.lane), (Le.lanes |= h), (ki |= h), (f = f.next));
      while (f !== t);
    } else f === null && (s.lanes = 0);
    return [i.memoizedState, s.dispatch];
  }
  function xu(t) {
    var i = Vt(),
      s = i.queue;
    if (s === null) throw Error(r(311));
    s.lastRenderedReducer = t;
    var a = s.dispatch,
      f = s.pending,
      h = i.memoizedState;
    if (f !== null) {
      s.pending = null;
      var y = (f = f.next);
      do ((h = t(h, y.action)), (y = y.next));
      while (y !== f);
      (en(h, i.memoizedState) || (Pt = !0),
        (i.memoizedState = h),
        i.baseQueue === null && (i.baseState = h),
        (s.lastRenderedState = h));
    }
    return [h, a];
  }
  function tf() {}
  function nf(t, i) {
    var s = Le,
      a = Vt(),
      f = i(),
      h = !en(a.memoizedState, f);
    if (
      (h && ((a.memoizedState = f), (Pt = !0)),
      (a = a.queue),
      _u(sf.bind(null, s, a, t), [t]),
      a.getSnapshot !== i || h || (Je !== null && Je.memoizedState.tag & 1))
    ) {
      if (
        ((s.flags |= 2048),
        zo(9, of.bind(null, s, a, f, i), void 0, null),
        et === null)
      )
        throw Error(r(349));
      bi & 30 || rf(s, i, f);
    }
    return f;
  }
  function rf(t, i, s) {
    ((t.flags |= 16384),
      (t = { getSnapshot: i, value: s }),
      (i = Le.updateQueue),
      i === null
        ? ((i = { lastEffect: null, stores: null }),
          (Le.updateQueue = i),
          (i.stores = [t]))
        : ((s = i.stores), s === null ? (i.stores = [t]) : s.push(t)));
  }
  function of(t, i, s, a) {
    ((i.value = s), (i.getSnapshot = a), lf(i) && af(t));
  }
  function sf(t, i, s) {
    return s(function () {
      lf(i) && af(t);
    });
  }
  function lf(t) {
    var i = t.getSnapshot;
    t = t.value;
    try {
      var s = i();
      return !en(t, s);
    } catch {
      return !0;
    }
  }
  function af(t) {
    var i = Dn(t, 1);
    i !== null && sn(i, t, 1, -1);
  }
  function uf(t) {
    var i = vn();
    return (
      typeof t == "function" && (t = t()),
      (i.memoizedState = i.baseState = t),
      (t = {
        pending: null,
        interleaved: null,
        lanes: 0,
        dispatch: null,
        lastRenderedReducer: Po,
        lastRenderedState: t,
      }),
      (i.queue = t),
      (t = t.dispatch = m4.bind(null, Le, t)),
      [i.memoizedState, t]
    );
  }
  function zo(t, i, s, a) {
    return (
      (t = { tag: t, create: i, destroy: s, deps: a, next: null }),
      (i = Le.updateQueue),
      i === null
        ? ((i = { lastEffect: null, stores: null }),
          (Le.updateQueue = i),
          (i.lastEffect = t.next = t))
        : ((s = i.lastEffect),
          s === null
            ? (i.lastEffect = t.next = t)
            : ((a = s.next), (s.next = t), (t.next = a), (i.lastEffect = t))),
      t
    );
  }
  function cf() {
    return Vt().memoizedState;
  }
  function $s(t, i, s, a) {
    var f = vn();
    ((Le.flags |= t),
      (f.memoizedState = zo(1 | i, s, void 0, a === void 0 ? null : a)));
  }
  function js(t, i, s, a) {
    var f = Vt();
    a = a === void 0 ? null : a;
    var h = void 0;
    if (Ye !== null) {
      var y = Ye.memoizedState;
      if (((h = y.destroy), a !== null && gu(a, y.deps))) {
        f.memoizedState = zo(i, s, h, a);
        return;
      }
    }
    ((Le.flags |= t), (f.memoizedState = zo(1 | i, s, h, a)));
  }
  function ff(t, i) {
    return $s(8390656, 8, t, i);
  }
  function _u(t, i) {
    return js(2048, 8, t, i);
  }
  function df(t, i) {
    return js(4, 2, t, i);
  }
  function hf(t, i) {
    return js(4, 4, t, i);
  }
  function pf(t, i) {
    if (typeof i == "function")
      return (
        (t = t()),
        i(t),
        function () {
          i(null);
        }
      );
    if (i != null)
      return (
        (t = t()),
        (i.current = t),
        function () {
          i.current = null;
        }
      );
  }
  function mf(t, i, s) {
    return (
      (s = s != null ? s.concat([t]) : null),
      js(4, 4, pf.bind(null, i, t), s)
    );
  }
  function bu() {}
  function yf(t, i) {
    var s = Vt();
    i = i === void 0 ? null : i;
    var a = s.memoizedState;
    return a !== null && i !== null && gu(i, a[1])
      ? a[0]
      : ((s.memoizedState = [t, i]), t);
  }
  function gf(t, i) {
    var s = Vt();
    i = i === void 0 ? null : i;
    var a = s.memoizedState;
    return a !== null && i !== null && gu(i, a[1])
      ? a[0]
      : ((t = t()), (s.memoizedState = [t, i]), t);
  }
  function vf(t, i, s) {
    return bi & 21
      ? (en(s, i) ||
          ((s = G3()), (Le.lanes |= s), (ki |= s), (t.baseState = !0)),
        i)
      : (t.baseState && ((t.baseState = !1), (Pt = !0)), (t.memoizedState = s));
  }
  function h4(t, i) {
    var s = ke;
    ((ke = s !== 0 && 4 > s ? s : 4), t(!0));
    var a = yu.transition;
    yu.transition = {};
    try {
      (t(!1), i());
    } finally {
      ((ke = s), (yu.transition = a));
    }
  }
  function Cf() {
    return Vt().memoizedState;
  }
  function p4(t, i, s) {
    var a = ni(t);
    if (
      ((s = {
        lane: a,
        action: s,
        hasEagerState: !1,
        eagerState: null,
        next: null,
      }),
      wf(t))
    )
      xf(i, s);
    else if (((s = K9(t, i, s, a)), s !== null)) {
      var f = _t();
      (sn(s, t, a, f), _f(s, i, a));
    }
  }
  function m4(t, i, s) {
    var a = ni(t),
      f = {
        lane: a,
        action: s,
        hasEagerState: !1,
        eagerState: null,
        next: null,
      };
    if (wf(t)) xf(i, f);
    else {
      var h = t.alternate;
      if (
        t.lanes === 0 &&
        (h === null || h.lanes === 0) &&
        ((h = i.lastRenderedReducer), h !== null)
      )
        try {
          var y = i.lastRenderedState,
            w = h(y, s);
          if (((f.hasEagerState = !0), (f.eagerState = w), en(w, y))) {
            var k = i.interleaved;
            (k === null
              ? ((f.next = f), cu(i))
              : ((f.next = k.next), (k.next = f)),
              (i.interleaved = f));
            return;
          }
        } catch {
        } finally {
        }
      ((s = K9(t, i, f, a)),
        s !== null && ((f = _t()), sn(s, t, a, f), _f(s, i, a)));
    }
  }
  function wf(t) {
    var i = t.alternate;
    return t === Le || (i !== null && i === Le);
  }
  function xf(t, i) {
    So = Ns = !0;
    var s = t.pending;
    (s === null ? (i.next = i) : ((i.next = s.next), (s.next = i)),
      (t.pending = i));
  }
  function _f(t, i, s) {
    if (s & 4194240) {
      var a = i.lanes;
      ((a &= t.pendingLanes), (s |= a), (i.lanes = s), Sa(t, s));
    }
  }
  var Bs = {
      readContext: Ht,
      useCallback: ht,
      useContext: ht,
      useEffect: ht,
      useImperativeHandle: ht,
      useInsertionEffect: ht,
      useLayoutEffect: ht,
      useMemo: ht,
      useReducer: ht,
      useRef: ht,
      useState: ht,
      useDebugValue: ht,
      useDeferredValue: ht,
      useTransition: ht,
      useMutableSource: ht,
      useSyncExternalStore: ht,
      useId: ht,
      unstable_isNewReconciler: !1,
    },
    y4 = {
      readContext: Ht,
      useCallback: function (t, i) {
        return ((vn().memoizedState = [t, i === void 0 ? null : i]), t);
      },
      useContext: Ht,
      useEffect: ff,
      useImperativeHandle: function (t, i, s) {
        return (
          (s = s != null ? s.concat([t]) : null),
          $s(4194308, 4, pf.bind(null, i, t), s)
        );
      },
      useLayoutEffect: function (t, i) {
        return $s(4194308, 4, t, i);
      },
      useInsertionEffect: function (t, i) {
        return $s(4, 2, t, i);
      },
      useMemo: function (t, i) {
        var s = vn();
        return (
          (i = i === void 0 ? null : i),
          (t = t()),
          (s.memoizedState = [t, i]),
          t
        );
      },
      useReducer: function (t, i, s) {
        var a = vn();
        return (
          (i = s !== void 0 ? s(i) : i),
          (a.memoizedState = a.baseState = i),
          (t = {
            pending: null,
            interleaved: null,
            lanes: 0,
            dispatch: null,
            lastRenderedReducer: t,
            lastRenderedState: i,
          }),
          (a.queue = t),
          (t = t.dispatch = p4.bind(null, Le, t)),
          [a.memoizedState, t]
        );
      },
      useRef: function (t) {
        var i = vn();
        return ((t = { current: t }), (i.memoizedState = t));
      },
      useState: uf,
      useDebugValue: bu,
      useDeferredValue: function (t) {
        return (vn().memoizedState = t);
      },
      useTransition: function () {
        var t = uf(!1),
          i = t[0];
        return ((t = h4.bind(null, t[1])), (vn().memoizedState = t), [i, t]);
      },
      useMutableSource: function () {},
      useSyncExternalStore: function (t, i, s) {
        var a = Le,
          f = vn();
        if (Te) {
          if (s === void 0) throw Error(r(407));
          s = s();
        } else {
          if (((s = i()), et === null)) throw Error(r(349));
          bi & 30 || rf(a, i, s);
        }
        f.memoizedState = s;
        var h = { value: s, getSnapshot: i };
        return (
          (f.queue = h),
          ff(sf.bind(null, a, h, t), [t]),
          (a.flags |= 2048),
          zo(9, of.bind(null, a, h, s, i), void 0, null),
          s
        );
      },
      useId: function () {
        var t = vn(),
          i = et.identifierPrefix;
        if (Te) {
          var s = Rn,
            a = Mn;
          ((s = (a & ~(1 << (32 - Jt(a) - 1))).toString(32) + s),
            (i = ":" + i + "R" + s),
            (s = Eo++),
            0 < s && (i += "H" + s.toString(32)),
            (i += ":"));
        } else ((s = d4++), (i = ":" + i + "r" + s.toString(32) + ":"));
        return (t.memoizedState = i);
      },
      unstable_isNewReconciler: !1,
    },
    g4 = {
      readContext: Ht,
      useCallback: yf,
      useContext: Ht,
      useEffect: _u,
      useImperativeHandle: mf,
      useInsertionEffect: df,
      useLayoutEffect: hf,
      useMemo: gf,
      useReducer: wu,
      useRef: cf,
      useState: function () {
        return wu(Po);
      },
      useDebugValue: bu,
      useDeferredValue: function (t) {
        var i = Vt();
        return vf(i, Ye.memoizedState, t);
      },
      useTransition: function () {
        var t = wu(Po)[0],
          i = Vt().memoizedState;
        return [t, i];
      },
      useMutableSource: tf,
      useSyncExternalStore: nf,
      useId: Cf,
      unstable_isNewReconciler: !1,
    },
    v4 = {
      readContext: Ht,
      useCallback: yf,
      useContext: Ht,
      useEffect: _u,
      useImperativeHandle: mf,
      useInsertionEffect: df,
      useLayoutEffect: hf,
      useMemo: gf,
      useReducer: xu,
      useRef: cf,
      useState: function () {
        return xu(Po);
      },
      useDebugValue: bu,
      useDeferredValue: function (t) {
        var i = Vt();
        return Ye === null ? (i.memoizedState = t) : vf(i, Ye.memoizedState, t);
      },
      useTransition: function () {
        var t = xu(Po)[0],
          i = Vt().memoizedState;
        return [t, i];
      },
      useMutableSource: tf,
      useSyncExternalStore: nf,
      useId: Cf,
      unstable_isNewReconciler: !1,
    };
  function nn(t, i) {
    if (t && t.defaultProps) {
      ((i = q({}, i)), (t = t.defaultProps));
      for (var s in t) i[s] === void 0 && (i[s] = t[s]);
      return i;
    }
    return i;
  }
  function ku(t, i, s, a) {
    ((i = t.memoizedState),
      (s = s(a, i)),
      (s = s == null ? i : q({}, i, s)),
      (t.memoizedState = s),
      t.lanes === 0 && (t.updateQueue.baseState = s));
  }
  var Us = {
    isMounted: function (t) {
      return (t = t._reactInternals) ? yi(t) === t : !1;
    },
    enqueueSetState: function (t, i, s) {
      t = t._reactInternals;
      var a = _t(),
        f = ni(t),
        h = Tn(a, f);
      ((h.payload = i),
        s != null && (h.callback = s),
        (i = Xn(t, h, f)),
        i !== null && (sn(i, t, f, a), Is(i, t, f)));
    },
    enqueueReplaceState: function (t, i, s) {
      t = t._reactInternals;
      var a = _t(),
        f = ni(t),
        h = Tn(a, f);
      ((h.tag = 1),
        (h.payload = i),
        s != null && (h.callback = s),
        (i = Xn(t, h, f)),
        i !== null && (sn(i, t, f, a), Is(i, t, f)));
    },
    enqueueForceUpdate: function (t, i) {
      t = t._reactInternals;
      var s = _t(),
        a = ni(t),
        f = Tn(s, a);
      ((f.tag = 2),
        i != null && (f.callback = i),
        (i = Xn(t, f, a)),
        i !== null && (sn(i, t, a, s), Is(i, t, a)));
    },
  };
  function bf(t, i, s, a, f, h, y) {
    return (
      (t = t.stateNode),
      typeof t.shouldComponentUpdate == "function"
        ? t.shouldComponentUpdate(a, h, y)
        : i.prototype && i.prototype.isPureReactComponent
          ? !po(s, a) || !po(f, h)
          : !0
    );
  }
  function kf(t, i, s) {
    var a = !1,
      f = Zn,
      h = i.contextType;
    return (
      typeof h == "object" && h !== null
        ? (h = Ht(h))
        : ((f = Et(i) ? vi : dt.current),
          (a = i.contextTypes),
          (h = (a = a != null) ? lr(t, f) : Zn)),
      (i = new i(s, h)),
      (t.memoizedState =
        i.state !== null && i.state !== void 0 ? i.state : null),
      (i.updater = Us),
      (t.stateNode = i),
      (i._reactInternals = t),
      a &&
        ((t = t.stateNode),
        (t.__reactInternalMemoizedUnmaskedChildContext = f),
        (t.__reactInternalMemoizedMaskedChildContext = h)),
      i
    );
  }
  function Sf(t, i, s, a) {
    ((t = i.state),
      typeof i.componentWillReceiveProps == "function" &&
        i.componentWillReceiveProps(s, a),
      typeof i.UNSAFE_componentWillReceiveProps == "function" &&
        i.UNSAFE_componentWillReceiveProps(s, a),
      i.state !== t && Us.enqueueReplaceState(i, i.state, null));
  }
  function Su(t, i, s, a) {
    var f = t.stateNode;
    ((f.props = s), (f.state = t.memoizedState), (f.refs = {}), fu(t));
    var h = i.contextType;
    (typeof h == "object" && h !== null
      ? (f.context = Ht(h))
      : ((h = Et(i) ? vi : dt.current), (f.context = lr(t, h))),
      (f.state = t.memoizedState),
      (h = i.getDerivedStateFromProps),
      typeof h == "function" && (ku(t, i, h, s), (f.state = t.memoizedState)),
      typeof i.getDerivedStateFromProps == "function" ||
        typeof f.getSnapshotBeforeUpdate == "function" ||
        (typeof f.UNSAFE_componentWillMount != "function" &&
          typeof f.componentWillMount != "function") ||
        ((i = f.state),
        typeof f.componentWillMount == "function" && f.componentWillMount(),
        typeof f.UNSAFE_componentWillMount == "function" &&
          f.UNSAFE_componentWillMount(),
        i !== f.state && Us.enqueueReplaceState(f, f.state, null),
        Ls(t, s, f, a),
        (f.state = t.memoizedState)),
      typeof f.componentDidMount == "function" && (t.flags |= 4194308));
  }
  function mr(t, i) {
    try {
      var s = "",
        a = i;
      do ((s += de(a)), (a = a.return));
      while (a);
      var f = s;
    } catch (h) {
      f =
        `
Error generating stack: ` +
        h.message +
        `
` +
        h.stack;
    }
    return { value: t, source: i, stack: f, digest: null };
  }
  function Eu(t, i, s) {
    return { value: t, source: null, stack: s ?? null, digest: i ?? null };
  }
  function Pu(t, i) {
    try {
      console.error(i.value);
    } catch (s) {
      setTimeout(function () {
        throw s;
      });
    }
  }
  var C4 = typeof WeakMap == "function" ? WeakMap : Map;
  function Ef(t, i, s) {
    ((s = Tn(-1, s)), (s.tag = 3), (s.payload = { element: null }));
    var a = i.value;
    return (
      (s.callback = function () {
        (Zs || ((Zs = !0), (Uu = a)), Pu(t, i));
      }),
      s
    );
  }
  function Pf(t, i, s) {
    ((s = Tn(-1, s)), (s.tag = 3));
    var a = t.type.getDerivedStateFromError;
    if (typeof a == "function") {
      var f = i.value;
      ((s.payload = function () {
        return a(f);
      }),
        (s.callback = function () {
          Pu(t, i);
        }));
    }
    var h = t.stateNode;
    return (
      h !== null &&
        typeof h.componentDidCatch == "function" &&
        (s.callback = function () {
          (Pu(t, i),
            typeof a != "function" &&
              (ei === null ? (ei = new Set([this])) : ei.add(this)));
          var y = i.stack;
          this.componentDidCatch(i.value, {
            componentStack: y !== null ? y : "",
          });
        }),
      s
    );
  }
  function zf(t, i, s) {
    var a = t.pingCache;
    if (a === null) {
      a = t.pingCache = new C4();
      var f = new Set();
      a.set(i, f);
    } else ((f = a.get(i)), f === void 0 && ((f = new Set()), a.set(i, f)));
    f.has(s) || (f.add(s), (t = T4.bind(null, t, i, s)), i.then(t, t));
  }
  function Of(t) {
    do {
      var i;
      if (
        ((i = t.tag === 13) &&
          ((i = t.memoizedState),
          (i = i !== null ? i.dehydrated !== null : !0)),
        i)
      )
        return t;
      t = t.return;
    } while (t !== null);
    return null;
  }
  function Mf(t, i, s, a, f) {
    return t.mode & 1
      ? ((t.flags |= 65536), (t.lanes = f), t)
      : (t === i
          ? (t.flags |= 65536)
          : ((t.flags |= 128),
            (s.flags |= 131072),
            (s.flags &= -52805),
            s.tag === 1 &&
              (s.alternate === null
                ? (s.tag = 17)
                : ((i = Tn(-1, 1)), (i.tag = 2), Xn(s, i, 1))),
            (s.lanes |= 1)),
        t);
  }
  var w4 = R.ReactCurrentOwner,
    Pt = !1;
  function xt(t, i, s, a) {
    i.child = t === null ? Z9(i, null, s, a) : fr(i, t.child, s, a);
  }
  function Rf(t, i, s, a, f) {
    s = s.render;
    var h = i.ref;
    return (
      hr(i, f),
      (a = vu(t, i, s, a, h, f)),
      (s = Cu()),
      t !== null && !Pt
        ? ((i.updateQueue = t.updateQueue),
          (i.flags &= -2053),
          (t.lanes &= ~f),
          In(t, i, f))
        : (Te && s && tu(i), (i.flags |= 1), xt(t, i, a, f), i.child)
    );
  }
  function Df(t, i, s, a, f) {
    if (t === null) {
      var h = s.type;
      return typeof h == "function" &&
        !Zu(h) &&
        h.defaultProps === void 0 &&
        s.compare === null &&
        s.defaultProps === void 0
        ? ((i.tag = 15), (i.type = h), Tf(t, i, h, a, f))
        : ((t = tl(s.type, null, a, i, i.mode, f)),
          (t.ref = i.ref),
          (t.return = i),
          (i.child = t));
    }
    if (((h = t.child), !(t.lanes & f))) {
      var y = h.memoizedProps;
      if (
        ((s = s.compare), (s = s !== null ? s : po), s(y, a) && t.ref === i.ref)
      )
        return In(t, i, f);
    }
    return (
      (i.flags |= 1),
      (t = ri(h, a)),
      (t.ref = i.ref),
      (t.return = i),
      (i.child = t)
    );
  }
  function Tf(t, i, s, a, f) {
    if (t !== null) {
      var h = t.memoizedProps;
      if (po(h, a) && t.ref === i.ref)
        if (((Pt = !1), (i.pendingProps = a = h), (t.lanes & f) !== 0))
          t.flags & 131072 && (Pt = !0);
        else return ((i.lanes = t.lanes), In(t, i, f));
    }
    return zu(t, i, s, a, f);
  }
  function If(t, i, s) {
    var a = i.pendingProps,
      f = a.children,
      h = t !== null ? t.memoizedState : null;
    if (a.mode === "hidden")
      if (!(i.mode & 1))
        ((i.memoizedState = {
          baseLanes: 0,
          cachePool: null,
          transitions: null,
        }),
          Pe(gr, Lt),
          (Lt |= s));
      else {
        if (!(s & 1073741824))
          return (
            (t = h !== null ? h.baseLanes | s : s),
            (i.lanes = i.childLanes = 1073741824),
            (i.memoizedState = {
              baseLanes: t,
              cachePool: null,
              transitions: null,
            }),
            (i.updateQueue = null),
            Pe(gr, Lt),
            (Lt |= t),
            null
          );
        ((i.memoizedState = {
          baseLanes: 0,
          cachePool: null,
          transitions: null,
        }),
          (a = h !== null ? h.baseLanes : s),
          Pe(gr, Lt),
          (Lt |= a));
      }
    else
      (h !== null ? ((a = h.baseLanes | s), (i.memoizedState = null)) : (a = s),
        Pe(gr, Lt),
        (Lt |= a));
    return (xt(t, i, f, s), i.child);
  }
  function Lf(t, i) {
    var s = i.ref;
    ((t === null && s !== null) || (t !== null && t.ref !== s)) &&
      ((i.flags |= 512), (i.flags |= 2097152));
  }
  function zu(t, i, s, a, f) {
    var h = Et(s) ? vi : dt.current;
    return (
      (h = lr(i, h)),
      hr(i, f),
      (s = vu(t, i, s, a, h, f)),
      (a = Cu()),
      t !== null && !Pt
        ? ((i.updateQueue = t.updateQueue),
          (i.flags &= -2053),
          (t.lanes &= ~f),
          In(t, i, f))
        : (Te && a && tu(i), (i.flags |= 1), xt(t, i, s, f), i.child)
    );
  }
  function Ff(t, i, s, a, f) {
    if (Et(s)) {
      var h = !0;
      Es(i);
    } else h = !1;
    if ((hr(i, f), i.stateNode === null))
      (Vs(t, i), kf(i, s, a), Su(i, s, a, f), (a = !0));
    else if (t === null) {
      var y = i.stateNode,
        w = i.memoizedProps;
      y.props = w;
      var k = y.context,
        M = s.contextType;
      typeof M == "object" && M !== null
        ? (M = Ht(M))
        : ((M = Et(s) ? vi : dt.current), (M = lr(i, M)));
      var j = s.getDerivedStateFromProps,
        B =
          typeof j == "function" ||
          typeof y.getSnapshotBeforeUpdate == "function";
      (B ||
        (typeof y.UNSAFE_componentWillReceiveProps != "function" &&
          typeof y.componentWillReceiveProps != "function") ||
        ((w !== a || k !== M) && Sf(i, y, a, M)),
        (Yn = !1));
      var A = i.memoizedState;
      ((y.state = A),
        Ls(i, a, y, f),
        (k = i.memoizedState),
        w !== a || A !== k || St.current || Yn
          ? (typeof j == "function" && (ku(i, s, j, a), (k = i.memoizedState)),
            (w = Yn || bf(i, s, w, a, A, k, M))
              ? (B ||
                  (typeof y.UNSAFE_componentWillMount != "function" &&
                    typeof y.componentWillMount != "function") ||
                  (typeof y.componentWillMount == "function" &&
                    y.componentWillMount(),
                  typeof y.UNSAFE_componentWillMount == "function" &&
                    y.UNSAFE_componentWillMount()),
                typeof y.componentDidMount == "function" &&
                  (i.flags |= 4194308))
              : (typeof y.componentDidMount == "function" &&
                  (i.flags |= 4194308),
                (i.memoizedProps = a),
                (i.memoizedState = k)),
            (y.props = a),
            (y.state = k),
            (y.context = M),
            (a = w))
          : (typeof y.componentDidMount == "function" && (i.flags |= 4194308),
            (a = !1)));
    } else {
      ((y = i.stateNode),
        Y9(t, i),
        (w = i.memoizedProps),
        (M = i.type === i.elementType ? w : nn(i.type, w)),
        (y.props = M),
        (B = i.pendingProps),
        (A = y.context),
        (k = s.contextType),
        typeof k == "object" && k !== null
          ? (k = Ht(k))
          : ((k = Et(s) ? vi : dt.current), (k = lr(i, k))));
      var G = s.getDerivedStateFromProps;
      ((j =
        typeof G == "function" ||
        typeof y.getSnapshotBeforeUpdate == "function") ||
        (typeof y.UNSAFE_componentWillReceiveProps != "function" &&
          typeof y.componentWillReceiveProps != "function") ||
        ((w !== B || A !== k) && Sf(i, y, a, k)),
        (Yn = !1),
        (A = i.memoizedState),
        (y.state = A),
        Ls(i, a, y, f));
      var Z = i.memoizedState;
      w !== B || A !== Z || St.current || Yn
        ? (typeof G == "function" && (ku(i, s, G, a), (Z = i.memoizedState)),
          (M = Yn || bf(i, s, M, a, A, Z, k) || !1)
            ? (j ||
                (typeof y.UNSAFE_componentWillUpdate != "function" &&
                  typeof y.componentWillUpdate != "function") ||
                (typeof y.componentWillUpdate == "function" &&
                  y.componentWillUpdate(a, Z, k),
                typeof y.UNSAFE_componentWillUpdate == "function" &&
                  y.UNSAFE_componentWillUpdate(a, Z, k)),
              typeof y.componentDidUpdate == "function" && (i.flags |= 4),
              typeof y.getSnapshotBeforeUpdate == "function" &&
                (i.flags |= 1024))
            : (typeof y.componentDidUpdate != "function" ||
                (w === t.memoizedProps && A === t.memoizedState) ||
                (i.flags |= 4),
              typeof y.getSnapshotBeforeUpdate != "function" ||
                (w === t.memoizedProps && A === t.memoizedState) ||
                (i.flags |= 1024),
              (i.memoizedProps = a),
              (i.memoizedState = Z)),
          (y.props = a),
          (y.state = Z),
          (y.context = k),
          (a = M))
        : (typeof y.componentDidUpdate != "function" ||
            (w === t.memoizedProps && A === t.memoizedState) ||
            (i.flags |= 4),
          typeof y.getSnapshotBeforeUpdate != "function" ||
            (w === t.memoizedProps && A === t.memoizedState) ||
            (i.flags |= 1024),
          (a = !1));
    }
    return Ou(t, i, s, a, h, f);
  }
  function Ou(t, i, s, a, f, h) {
    Lf(t, i);
    var y = (i.flags & 128) !== 0;
    if (!a && !y) return (f && j9(i, s, !1), In(t, i, h));
    ((a = i.stateNode), (w4.current = i));
    var w =
      y && typeof s.getDerivedStateFromError != "function" ? null : a.render();
    return (
      (i.flags |= 1),
      t !== null && y
        ? ((i.child = fr(i, t.child, null, h)), (i.child = fr(i, null, w, h)))
        : xt(t, i, w, h),
      (i.memoizedState = a.state),
      f && j9(i, s, !0),
      i.child
    );
  }
  function Af(t) {
    var i = t.stateNode;
    (i.pendingContext
      ? N9(t, i.pendingContext, i.pendingContext !== i.context)
      : i.context && N9(t, i.context, !1),
      du(t, i.containerInfo));
  }
  function Nf(t, i, s, a, f) {
    return (cr(), ou(f), (i.flags |= 256), xt(t, i, s, a), i.child);
  }
  var Mu = { dehydrated: null, treeContext: null, retryLane: 0 };
  function Ru(t) {
    return { baseLanes: t, cachePool: null, transitions: null };
  }
  function $f(t, i, s) {
    var a = i.pendingProps,
      f = Ie.current,
      h = !1,
      y = (i.flags & 128) !== 0,
      w;
    if (
      ((w = y) ||
        (w = t !== null && t.memoizedState === null ? !1 : (f & 2) !== 0),
      w
        ? ((h = !0), (i.flags &= -129))
        : (t === null || t.memoizedState !== null) && (f |= 1),
      Pe(Ie, f & 1),
      t === null)
    )
      return (
        ru(i),
        (t = i.memoizedState),
        t !== null && ((t = t.dehydrated), t !== null)
          ? (i.mode & 1
              ? t.data === "$!"
                ? (i.lanes = 8)
                : (i.lanes = 1073741824)
              : (i.lanes = 1),
            null)
          : ((y = a.children),
            (t = a.fallback),
            h
              ? ((a = i.mode),
                (h = i.child),
                (y = { mode: "hidden", children: y }),
                !(a & 1) && h !== null
                  ? ((h.childLanes = 0), (h.pendingProps = y))
                  : (h = nl(y, a, 0, null)),
                (t = zi(t, a, s, null)),
                (h.return = i),
                (t.return = i),
                (h.sibling = t),
                (i.child = h),
                (i.child.memoizedState = Ru(s)),
                (i.memoizedState = Mu),
                t)
              : Du(i, y))
      );
    if (((f = t.memoizedState), f !== null && ((w = f.dehydrated), w !== null)))
      return x4(t, i, y, a, w, f, s);
    if (h) {
      ((h = a.fallback), (y = i.mode), (f = t.child), (w = f.sibling));
      var k = { mode: "hidden", children: a.children };
      return (
        !(y & 1) && i.child !== f
          ? ((a = i.child),
            (a.childLanes = 0),
            (a.pendingProps = k),
            (i.deletions = null))
          : ((a = ri(f, k)), (a.subtreeFlags = f.subtreeFlags & 14680064)),
        w !== null ? (h = ri(w, h)) : ((h = zi(h, y, s, null)), (h.flags |= 2)),
        (h.return = i),
        (a.return = i),
        (a.sibling = h),
        (i.child = a),
        (a = h),
        (h = i.child),
        (y = t.child.memoizedState),
        (y =
          y === null
            ? Ru(s)
            : {
                baseLanes: y.baseLanes | s,
                cachePool: null,
                transitions: y.transitions,
              }),
        (h.memoizedState = y),
        (h.childLanes = t.childLanes & ~s),
        (i.memoizedState = Mu),
        a
      );
    }
    return (
      (h = t.child),
      (t = h.sibling),
      (a = ri(h, { mode: "visible", children: a.children })),
      !(i.mode & 1) && (a.lanes = s),
      (a.return = i),
      (a.sibling = null),
      t !== null &&
        ((s = i.deletions),
        s === null ? ((i.deletions = [t]), (i.flags |= 16)) : s.push(t)),
      (i.child = a),
      (i.memoizedState = null),
      a
    );
  }
  function Du(t, i) {
    return (
      (i = nl({ mode: "visible", children: i }, t.mode, 0, null)),
      (i.return = t),
      (t.child = i)
    );
  }
  function Hs(t, i, s, a) {
    return (
      a !== null && ou(a),
      fr(i, t.child, null, s),
      (t = Du(i, i.pendingProps.children)),
      (t.flags |= 2),
      (i.memoizedState = null),
      t
    );
  }
  function x4(t, i, s, a, f, h, y) {
    if (s)
      return i.flags & 256
        ? ((i.flags &= -257), (a = Eu(Error(r(422)))), Hs(t, i, y, a))
        : i.memoizedState !== null
          ? ((i.child = t.child), (i.flags |= 128), null)
          : ((h = a.fallback),
            (f = i.mode),
            (a = nl({ mode: "visible", children: a.children }, f, 0, null)),
            (h = zi(h, f, y, null)),
            (h.flags |= 2),
            (a.return = i),
            (h.return = i),
            (a.sibling = h),
            (i.child = a),
            i.mode & 1 && fr(i, t.child, null, y),
            (i.child.memoizedState = Ru(y)),
            (i.memoizedState = Mu),
            h);
    if (!(i.mode & 1)) return Hs(t, i, y, null);
    if (f.data === "$!") {
      if (((a = f.nextSibling && f.nextSibling.dataset), a)) var w = a.dgst;
      return (
        (a = w),
        (h = Error(r(419))),
        (a = Eu(h, a, void 0)),
        Hs(t, i, y, a)
      );
    }
    if (((w = (y & t.childLanes) !== 0), Pt || w)) {
      if (((a = et), a !== null)) {
        switch (y & -y) {
          case 4:
            f = 2;
            break;
          case 16:
            f = 8;
            break;
          case 64:
          case 128:
          case 256:
          case 512:
          case 1024:
          case 2048:
          case 4096:
          case 8192:
          case 16384:
          case 32768:
          case 65536:
          case 131072:
          case 262144:
          case 524288:
          case 1048576:
          case 2097152:
          case 4194304:
          case 8388608:
          case 16777216:
          case 33554432:
          case 67108864:
            f = 32;
            break;
          case 536870912:
            f = 268435456;
            break;
          default:
            f = 0;
        }
        ((f = f & (a.suspendedLanes | y) ? 0 : f),
          f !== 0 &&
            f !== h.retryLane &&
            ((h.retryLane = f), Dn(t, f), sn(a, t, f, -1)));
      }
      return (Qu(), (a = Eu(Error(r(421)))), Hs(t, i, y, a));
    }
    return f.data === "$?"
      ? ((i.flags |= 128),
        (i.child = t.child),
        (i = I4.bind(null, t)),
        (f._reactRetry = i),
        null)
      : ((t = h.treeContext),
        (It = Gn(f.nextSibling)),
        (Tt = i),
        (Te = !0),
        (tn = null),
        t !== null &&
          ((Bt[Ut++] = Mn),
          (Bt[Ut++] = Rn),
          (Bt[Ut++] = Ci),
          (Mn = t.id),
          (Rn = t.overflow),
          (Ci = i)),
        (i = Du(i, a.children)),
        (i.flags |= 4096),
        i);
  }
  function jf(t, i, s) {
    t.lanes |= i;
    var a = t.alternate;
    (a !== null && (a.lanes |= i), uu(t.return, i, s));
  }
  function Tu(t, i, s, a, f) {
    var h = t.memoizedState;
    h === null
      ? (t.memoizedState = {
          isBackwards: i,
          rendering: null,
          renderingStartTime: 0,
          last: a,
          tail: s,
          tailMode: f,
        })
      : ((h.isBackwards = i),
        (h.rendering = null),
        (h.renderingStartTime = 0),
        (h.last = a),
        (h.tail = s),
        (h.tailMode = f));
  }
  function Bf(t, i, s) {
    var a = i.pendingProps,
      f = a.revealOrder,
      h = a.tail;
    if ((xt(t, i, a.children, s), (a = Ie.current), a & 2))
      ((a = (a & 1) | 2), (i.flags |= 128));
    else {
      if (t !== null && t.flags & 128)
        e: for (t = i.child; t !== null;) {
          if (t.tag === 13) t.memoizedState !== null && jf(t, s, i);
          else if (t.tag === 19) jf(t, s, i);
          else if (t.child !== null) {
            ((t.child.return = t), (t = t.child));
            continue;
          }
          if (t === i) break e;
          for (; t.sibling === null;) {
            if (t.return === null || t.return === i) break e;
            t = t.return;
          }
          ((t.sibling.return = t.return), (t = t.sibling));
        }
      a &= 1;
    }
    if ((Pe(Ie, a), !(i.mode & 1))) i.memoizedState = null;
    else
      switch (f) {
        case "forwards":
          for (s = i.child, f = null; s !== null;)
            ((t = s.alternate),
              t !== null && Fs(t) === null && (f = s),
              (s = s.sibling));
          ((s = f),
            s === null
              ? ((f = i.child), (i.child = null))
              : ((f = s.sibling), (s.sibling = null)),
            Tu(i, !1, f, s, h));
          break;
        case "backwards":
          for (s = null, f = i.child, i.child = null; f !== null;) {
            if (((t = f.alternate), t !== null && Fs(t) === null)) {
              i.child = f;
              break;
            }
            ((t = f.sibling), (f.sibling = s), (s = f), (f = t));
          }
          Tu(i, !0, s, null, h);
          break;
        case "together":
          Tu(i, !1, null, null, void 0);
          break;
        default:
          i.memoizedState = null;
      }
    return i.child;
  }
  function Vs(t, i) {
    !(i.mode & 1) &&
      t !== null &&
      ((t.alternate = null), (i.alternate = null), (i.flags |= 2));
  }
  function In(t, i, s) {
    if (
      (t !== null && (i.dependencies = t.dependencies),
      (ki |= i.lanes),
      !(s & i.childLanes))
    )
      return null;
    if (t !== null && i.child !== t.child) throw Error(r(153));
    if (i.child !== null) {
      for (
        t = i.child, s = ri(t, t.pendingProps), i.child = s, s.return = i;
        t.sibling !== null;
      )
        ((t = t.sibling),
          (s = s.sibling = ri(t, t.pendingProps)),
          (s.return = i));
      s.sibling = null;
    }
    return i.child;
  }
  function _4(t, i, s) {
    switch (i.tag) {
      case 3:
        (Af(i), cr());
        break;
      case 5:
        ef(i);
        break;
      case 1:
        Et(i.type) && Es(i);
        break;
      case 4:
        du(i, i.stateNode.containerInfo);
        break;
      case 10:
        var a = i.type._context,
          f = i.memoizedProps.value;
        (Pe(Ds, a._currentValue), (a._currentValue = f));
        break;
      case 13:
        if (((a = i.memoizedState), a !== null))
          return a.dehydrated !== null
            ? (Pe(Ie, Ie.current & 1), (i.flags |= 128), null)
            : s & i.child.childLanes
              ? $f(t, i, s)
              : (Pe(Ie, Ie.current & 1),
                (t = In(t, i, s)),
                t !== null ? t.sibling : null);
        Pe(Ie, Ie.current & 1);
        break;
      case 19:
        if (((a = (s & i.childLanes) !== 0), t.flags & 128)) {
          if (a) return Bf(t, i, s);
          i.flags |= 128;
        }
        if (
          ((f = i.memoizedState),
          f !== null &&
            ((f.rendering = null), (f.tail = null), (f.lastEffect = null)),
          Pe(Ie, Ie.current),
          a)
        )
          break;
        return null;
      case 22:
      case 23:
        return ((i.lanes = 0), If(t, i, s));
    }
    return In(t, i, s);
  }
  var Uf, Iu, Hf, Vf;
  ((Uf = function (t, i) {
    for (var s = i.child; s !== null;) {
      if (s.tag === 5 || s.tag === 6) t.appendChild(s.stateNode);
      else if (s.tag !== 4 && s.child !== null) {
        ((s.child.return = s), (s = s.child));
        continue;
      }
      if (s === i) break;
      for (; s.sibling === null;) {
        if (s.return === null || s.return === i) return;
        s = s.return;
      }
      ((s.sibling.return = s.return), (s = s.sibling));
    }
  }),
    (Iu = function () {}),
    (Hf = function (t, i, s, a) {
      var f = t.memoizedProps;
      if (f !== a) {
        ((t = i.stateNode), _i(gn.current));
        var h = null;
        switch (s) {
          case "input":
            ((f = ua(t, f)), (a = ua(t, a)), (h = []));
            break;
          case "select":
            ((f = q({}, f, { value: void 0 })),
              (a = q({}, a, { value: void 0 })),
              (h = []));
            break;
          case "textarea":
            ((f = da(t, f)), (a = da(t, a)), (h = []));
            break;
          default:
            typeof f.onClick != "function" &&
              typeof a.onClick == "function" &&
              (t.onclick = bs);
        }
        pa(s, a);
        var y;
        s = null;
        for (M in f)
          if (!a.hasOwnProperty(M) && f.hasOwnProperty(M) && f[M] != null)
            if (M === "style") {
              var w = f[M];
              for (y in w) w.hasOwnProperty(y) && (s || (s = {}), (s[y] = ""));
            } else
              M !== "dangerouslySetInnerHTML" &&
                M !== "children" &&
                M !== "suppressContentEditableWarning" &&
                M !== "suppressHydrationWarning" &&
                M !== "autoFocus" &&
                (l.hasOwnProperty(M)
                  ? h || (h = [])
                  : (h = h || []).push(M, null));
        for (M in a) {
          var k = a[M];
          if (
            ((w = f != null ? f[M] : void 0),
            a.hasOwnProperty(M) && k !== w && (k != null || w != null))
          )
            if (M === "style")
              if (w) {
                for (y in w)
                  !w.hasOwnProperty(y) ||
                    (k && k.hasOwnProperty(y)) ||
                    (s || (s = {}), (s[y] = ""));
                for (y in k)
                  k.hasOwnProperty(y) &&
                    w[y] !== k[y] &&
                    (s || (s = {}), (s[y] = k[y]));
              } else (s || (h || (h = []), h.push(M, s)), (s = k));
            else
              M === "dangerouslySetInnerHTML"
                ? ((k = k ? k.__html : void 0),
                  (w = w ? w.__html : void 0),
                  k != null && w !== k && (h = h || []).push(M, k))
                : M === "children"
                  ? (typeof k != "string" && typeof k != "number") ||
                    (h = h || []).push(M, "" + k)
                  : M !== "suppressContentEditableWarning" &&
                    M !== "suppressHydrationWarning" &&
                    (l.hasOwnProperty(M)
                      ? (k != null && M === "onScroll" && Me("scroll", t),
                        h || w === k || (h = []))
                      : (h = h || []).push(M, k));
        }
        s && (h = h || []).push("style", s);
        var M = h;
        (i.updateQueue = M) && (i.flags |= 4);
      }
    }),
    (Vf = function (t, i, s, a) {
      s !== a && (i.flags |= 4);
    }));
  function Oo(t, i) {
    if (!Te)
      switch (t.tailMode) {
        case "hidden":
          i = t.tail;
          for (var s = null; i !== null;)
            (i.alternate !== null && (s = i), (i = i.sibling));
          s === null ? (t.tail = null) : (s.sibling = null);
          break;
        case "collapsed":
          s = t.tail;
          for (var a = null; s !== null;)
            (s.alternate !== null && (a = s), (s = s.sibling));
          a === null
            ? i || t.tail === null
              ? (t.tail = null)
              : (t.tail.sibling = null)
            : (a.sibling = null);
      }
  }
  function pt(t) {
    var i = t.alternate !== null && t.alternate.child === t.child,
      s = 0,
      a = 0;
    if (i)
      for (var f = t.child; f !== null;)
        ((s |= f.lanes | f.childLanes),
          (a |= f.subtreeFlags & 14680064),
          (a |= f.flags & 14680064),
          (f.return = t),
          (f = f.sibling));
    else
      for (f = t.child; f !== null;)
        ((s |= f.lanes | f.childLanes),
          (a |= f.subtreeFlags),
          (a |= f.flags),
          (f.return = t),
          (f = f.sibling));
    return ((t.subtreeFlags |= a), (t.childLanes = s), i);
  }
  function b4(t, i, s) {
    var a = i.pendingProps;
    switch ((nu(i), i.tag)) {
      case 2:
      case 16:
      case 15:
      case 0:
      case 11:
      case 7:
      case 8:
      case 12:
      case 9:
      case 14:
        return (pt(i), null);
      case 1:
        return (Et(i.type) && Ss(), pt(i), null);
      case 3:
        return (
          (a = i.stateNode),
          pr(),
          Re(St),
          Re(dt),
          mu(),
          a.pendingContext &&
            ((a.context = a.pendingContext), (a.pendingContext = null)),
          (t === null || t.child === null) &&
            (Ms(i)
              ? (i.flags |= 4)
              : t === null ||
                (t.memoizedState.isDehydrated && !(i.flags & 256)) ||
                ((i.flags |= 1024), tn !== null && (Wu(tn), (tn = null)))),
          Iu(t, i),
          pt(i),
          null
        );
      case 5:
        hu(i);
        var f = _i(ko.current);
        if (((s = i.type), t !== null && i.stateNode != null))
          (Hf(t, i, s, a, f),
            t.ref !== i.ref && ((i.flags |= 512), (i.flags |= 2097152)));
        else {
          if (!a) {
            if (i.stateNode === null) throw Error(r(166));
            return (pt(i), null);
          }
          if (((t = _i(gn.current)), Ms(i))) {
            ((a = i.stateNode), (s = i.type));
            var h = i.memoizedProps;
            switch (((a[yn] = i), (a[Co] = h), (t = (i.mode & 1) !== 0), s)) {
              case "dialog":
                (Me("cancel", a), Me("close", a));
                break;
              case "iframe":
              case "object":
              case "embed":
                Me("load", a);
                break;
              case "video":
              case "audio":
                for (f = 0; f < yo.length; f++) Me(yo[f], a);
                break;
              case "source":
                Me("error", a);
                break;
              case "img":
              case "image":
              case "link":
                (Me("error", a), Me("load", a));
                break;
              case "details":
                Me("toggle", a);
                break;
              case "input":
                (b3(a, h), Me("invalid", a));
                break;
              case "select":
                ((a._wrapperState = { wasMultiple: !!h.multiple }),
                  Me("invalid", a));
                break;
              case "textarea":
                (E3(a, h), Me("invalid", a));
            }
            (pa(s, h), (f = null));
            for (var y in h)
              if (h.hasOwnProperty(y)) {
                var w = h[y];
                y === "children"
                  ? typeof w == "string"
                    ? a.textContent !== w &&
                      (h.suppressHydrationWarning !== !0 &&
                        _s(a.textContent, w, t),
                      (f = ["children", w]))
                    : typeof w == "number" &&
                      a.textContent !== "" + w &&
                      (h.suppressHydrationWarning !== !0 &&
                        _s(a.textContent, w, t),
                      (f = ["children", "" + w]))
                  : l.hasOwnProperty(y) &&
                    w != null &&
                    y === "onScroll" &&
                    Me("scroll", a);
              }
            switch (s) {
              case "input":
                (Pn(a), S3(a, h, !0));
                break;
              case "textarea":
                (Pn(a), z3(a));
                break;
              case "select":
              case "option":
                break;
              default:
                typeof h.onClick == "function" && (a.onclick = bs);
            }
            ((a = f), (i.updateQueue = a), a !== null && (i.flags |= 4));
          } else {
            ((y = f.nodeType === 9 ? f : f.ownerDocument),
              t === "http://www.w3.org/1999/xhtml" && (t = O3(s)),
              t === "http://www.w3.org/1999/xhtml"
                ? s === "script"
                  ? ((t = y.createElement("div")),
                    (t.innerHTML = "<script><\/script>"),
                    (t = t.removeChild(t.firstChild)))
                  : typeof a.is == "string"
                    ? (t = y.createElement(s, { is: a.is }))
                    : ((t = y.createElement(s)),
                      s === "select" &&
                        ((y = t),
                        a.multiple
                          ? (y.multiple = !0)
                          : a.size && (y.size = a.size)))
                : (t = y.createElementNS(t, s)),
              (t[yn] = i),
              (t[Co] = a),
              Uf(t, i, !1, !1),
              (i.stateNode = t));
            e: {
              switch (((y = ma(s, a)), s)) {
                case "dialog":
                  (Me("cancel", t), Me("close", t), (f = a));
                  break;
                case "iframe":
                case "object":
                case "embed":
                  (Me("load", t), (f = a));
                  break;
                case "video":
                case "audio":
                  for (f = 0; f < yo.length; f++) Me(yo[f], t);
                  f = a;
                  break;
                case "source":
                  (Me("error", t), (f = a));
                  break;
                case "img":
                case "image":
                case "link":
                  (Me("error", t), Me("load", t), (f = a));
                  break;
                case "details":
                  (Me("toggle", t), (f = a));
                  break;
                case "input":
                  (b3(t, a), (f = ua(t, a)), Me("invalid", t));
                  break;
                case "option":
                  f = a;
                  break;
                case "select":
                  ((t._wrapperState = { wasMultiple: !!a.multiple }),
                    (f = q({}, a, { value: void 0 })),
                    Me("invalid", t));
                  break;
                case "textarea":
                  (E3(t, a), (f = da(t, a)), Me("invalid", t));
                  break;
                default:
                  f = a;
              }
              (pa(s, f), (w = f));
              for (h in w)
                if (w.hasOwnProperty(h)) {
                  var k = w[h];
                  h === "style"
                    ? D3(t, k)
                    : h === "dangerouslySetInnerHTML"
                      ? ((k = k ? k.__html : void 0), k != null && M3(t, k))
                      : h === "children"
                        ? typeof k == "string"
                          ? (s !== "textarea" || k !== "") && Kr(t, k)
                          : typeof k == "number" && Kr(t, "" + k)
                        : h !== "suppressContentEditableWarning" &&
                          h !== "suppressHydrationWarning" &&
                          h !== "autoFocus" &&
                          (l.hasOwnProperty(h)
                            ? k != null && h === "onScroll" && Me("scroll", t)
                            : k != null && I(t, h, k, y));
                }
              switch (s) {
                case "input":
                  (Pn(t), S3(t, a, !1));
                  break;
                case "textarea":
                  (Pn(t), z3(t));
                  break;
                case "option":
                  a.value != null && t.setAttribute("value", "" + ye(a.value));
                  break;
                case "select":
                  ((t.multiple = !!a.multiple),
                    (h = a.value),
                    h != null
                      ? Zi(t, !!a.multiple, h, !1)
                      : a.defaultValue != null &&
                        Zi(t, !!a.multiple, a.defaultValue, !0));
                  break;
                default:
                  typeof f.onClick == "function" && (t.onclick = bs);
              }
              switch (s) {
                case "button":
                case "input":
                case "select":
                case "textarea":
                  a = !!a.autoFocus;
                  break e;
                case "img":
                  a = !0;
                  break e;
                default:
                  a = !1;
              }
            }
            a && (i.flags |= 4);
          }
          i.ref !== null && ((i.flags |= 512), (i.flags |= 2097152));
        }
        return (pt(i), null);
      case 6:
        if (t && i.stateNode != null) Vf(t, i, t.memoizedProps, a);
        else {
          if (typeof a != "string" && i.stateNode === null) throw Error(r(166));
          if (((s = _i(ko.current)), _i(gn.current), Ms(i))) {
            if (
              ((a = i.stateNode),
              (s = i.memoizedProps),
              (a[yn] = i),
              (h = a.nodeValue !== s) && ((t = Tt), t !== null))
            )
              switch (t.tag) {
                case 3:
                  _s(a.nodeValue, s, (t.mode & 1) !== 0);
                  break;
                case 5:
                  t.memoizedProps.suppressHydrationWarning !== !0 &&
                    _s(a.nodeValue, s, (t.mode & 1) !== 0);
              }
            h && (i.flags |= 4);
          } else
            ((a = (s.nodeType === 9 ? s : s.ownerDocument).createTextNode(a)),
              (a[yn] = i),
              (i.stateNode = a));
        }
        return (pt(i), null);
      case 13:
        if (
          (Re(Ie),
          (a = i.memoizedState),
          t === null ||
            (t.memoizedState !== null && t.memoizedState.dehydrated !== null))
        ) {
          if (Te && It !== null && i.mode & 1 && !(i.flags & 128))
            (q9(), cr(), (i.flags |= 98560), (h = !1));
          else if (((h = Ms(i)), a !== null && a.dehydrated !== null)) {
            if (t === null) {
              if (!h) throw Error(r(318));
              if (
                ((h = i.memoizedState),
                (h = h !== null ? h.dehydrated : null),
                !h)
              )
                throw Error(r(317));
              h[yn] = i;
            } else
              (cr(),
                !(i.flags & 128) && (i.memoizedState = null),
                (i.flags |= 4));
            (pt(i), (h = !1));
          } else (tn !== null && (Wu(tn), (tn = null)), (h = !0));
          if (!h) return i.flags & 65536 ? i : null;
        }
        return i.flags & 128
          ? ((i.lanes = s), i)
          : ((a = a !== null),
            a !== (t !== null && t.memoizedState !== null) &&
              a &&
              ((i.child.flags |= 8192),
              i.mode & 1 &&
                (t === null || Ie.current & 1 ? Xe === 0 && (Xe = 3) : Qu())),
            i.updateQueue !== null && (i.flags |= 4),
            pt(i),
            null);
      case 4:
        return (
          pr(),
          Iu(t, i),
          t === null && go(i.stateNode.containerInfo),
          pt(i),
          null
        );
      case 10:
        return (au(i.type._context), pt(i), null);
      case 17:
        return (Et(i.type) && Ss(), pt(i), null);
      case 19:
        if ((Re(Ie), (h = i.memoizedState), h === null)) return (pt(i), null);
        if (((a = (i.flags & 128) !== 0), (y = h.rendering), y === null))
          if (a) Oo(h, !1);
          else {
            if (Xe !== 0 || (t !== null && t.flags & 128))
              for (t = i.child; t !== null;) {
                if (((y = Fs(t)), y !== null)) {
                  for (
                    i.flags |= 128,
                      Oo(h, !1),
                      a = y.updateQueue,
                      a !== null && ((i.updateQueue = a), (i.flags |= 4)),
                      i.subtreeFlags = 0,
                      a = s,
                      s = i.child;
                    s !== null;
                  )
                    ((h = s),
                      (t = a),
                      (h.flags &= 14680066),
                      (y = h.alternate),
                      y === null
                        ? ((h.childLanes = 0),
                          (h.lanes = t),
                          (h.child = null),
                          (h.subtreeFlags = 0),
                          (h.memoizedProps = null),
                          (h.memoizedState = null),
                          (h.updateQueue = null),
                          (h.dependencies = null),
                          (h.stateNode = null))
                        : ((h.childLanes = y.childLanes),
                          (h.lanes = y.lanes),
                          (h.child = y.child),
                          (h.subtreeFlags = 0),
                          (h.deletions = null),
                          (h.memoizedProps = y.memoizedProps),
                          (h.memoizedState = y.memoizedState),
                          (h.updateQueue = y.updateQueue),
                          (h.type = y.type),
                          (t = y.dependencies),
                          (h.dependencies =
                            t === null
                              ? null
                              : {
                                  lanes: t.lanes,
                                  firstContext: t.firstContext,
                                })),
                      (s = s.sibling));
                  return (Pe(Ie, (Ie.current & 1) | 2), i.child);
                }
                t = t.sibling;
              }
            h.tail !== null &&
              Ue() > vr &&
              ((i.flags |= 128), (a = !0), Oo(h, !1), (i.lanes = 4194304));
          }
        else {
          if (!a)
            if (((t = Fs(y)), t !== null)) {
              if (
                ((i.flags |= 128),
                (a = !0),
                (s = t.updateQueue),
                s !== null && ((i.updateQueue = s), (i.flags |= 4)),
                Oo(h, !0),
                h.tail === null &&
                  h.tailMode === "hidden" &&
                  !y.alternate &&
                  !Te)
              )
                return (pt(i), null);
            } else
              2 * Ue() - h.renderingStartTime > vr &&
                s !== 1073741824 &&
                ((i.flags |= 128), (a = !0), Oo(h, !1), (i.lanes = 4194304));
          h.isBackwards
            ? ((y.sibling = i.child), (i.child = y))
            : ((s = h.last),
              s !== null ? (s.sibling = y) : (i.child = y),
              (h.last = y));
        }
        return h.tail !== null
          ? ((i = h.tail),
            (h.rendering = i),
            (h.tail = i.sibling),
            (h.renderingStartTime = Ue()),
            (i.sibling = null),
            (s = Ie.current),
            Pe(Ie, a ? (s & 1) | 2 : s & 1),
            i)
          : (pt(i), null);
      case 22:
      case 23:
        return (
          Gu(),
          (a = i.memoizedState !== null),
          t !== null && (t.memoizedState !== null) !== a && (i.flags |= 8192),
          a && i.mode & 1
            ? Lt & 1073741824 &&
              (pt(i), i.subtreeFlags & 6 && (i.flags |= 8192))
            : pt(i),
          null
        );
      case 24:
        return null;
      case 25:
        return null;
    }
    throw Error(r(156, i.tag));
  }
  function k4(t, i) {
    switch ((nu(i), i.tag)) {
      case 1:
        return (
          Et(i.type) && Ss(),
          (t = i.flags),
          t & 65536 ? ((i.flags = (t & -65537) | 128), i) : null
        );
      case 3:
        return (
          pr(),
          Re(St),
          Re(dt),
          mu(),
          (t = i.flags),
          t & 65536 && !(t & 128) ? ((i.flags = (t & -65537) | 128), i) : null
        );
      case 5:
        return (hu(i), null);
      case 13:
        if (
          (Re(Ie), (t = i.memoizedState), t !== null && t.dehydrated !== null)
        ) {
          if (i.alternate === null) throw Error(r(340));
          cr();
        }
        return (
          (t = i.flags),
          t & 65536 ? ((i.flags = (t & -65537) | 128), i) : null
        );
      case 19:
        return (Re(Ie), null);
      case 4:
        return (pr(), null);
      case 10:
        return (au(i.type._context), null);
      case 22:
      case 23:
        return (Gu(), null);
      case 24:
        return null;
      default:
        return null;
    }
  }
  var Ws = !1,
    mt = !1,
    S4 = typeof WeakSet == "function" ? WeakSet : Set,
    Q = null;
  function yr(t, i) {
    var s = t.ref;
    if (s !== null)
      if (typeof s == "function")
        try {
          s(null);
        } catch (a) {
          Ae(t, i, a);
        }
      else s.current = null;
  }
  function Lu(t, i, s) {
    try {
      s();
    } catch (a) {
      Ae(t, i, a);
    }
  }
  var Wf = !1;
  function E4(t, i) {
    if (((Ga = fs), (t = _9()), $a(t))) {
      if ("selectionStart" in t)
        var s = { start: t.selectionStart, end: t.selectionEnd };
      else
        e: {
          s = ((s = t.ownerDocument) && s.defaultView) || window;
          var a = s.getSelection && s.getSelection();
          if (a && a.rangeCount !== 0) {
            s = a.anchorNode;
            var f = a.anchorOffset,
              h = a.focusNode;
            a = a.focusOffset;
            try {
              (s.nodeType, h.nodeType);
            } catch {
              s = null;
              break e;
            }
            var y = 0,
              w = -1,
              k = -1,
              M = 0,
              j = 0,
              B = t,
              A = null;
            t: for (;;) {
              for (
                var G;
                B !== s || (f !== 0 && B.nodeType !== 3) || (w = y + f),
                  B !== h || (a !== 0 && B.nodeType !== 3) || (k = y + a),
                  B.nodeType === 3 && (y += B.nodeValue.length),
                  (G = B.firstChild) !== null;
              )
                ((A = B), (B = G));
              for (;;) {
                if (B === t) break t;
                if (
                  (A === s && ++M === f && (w = y),
                  A === h && ++j === a && (k = y),
                  (G = B.nextSibling) !== null)
                )
                  break;
                ((B = A), (A = B.parentNode));
              }
              B = G;
            }
            s = w === -1 || k === -1 ? null : { start: w, end: k };
          } else s = null;
        }
      s = s || { start: 0, end: 0 };
    } else s = null;
    for (
      Qa = { focusedElem: t, selectionRange: s }, fs = !1, Q = i;
      Q !== null;
    )
      if (((i = Q), (t = i.child), (i.subtreeFlags & 1028) !== 0 && t !== null))
        ((t.return = i), (Q = t));
      else
        for (; Q !== null;) {
          i = Q;
          try {
            var Z = i.alternate;
            if (i.flags & 1024)
              switch (i.tag) {
                case 0:
                case 11:
                case 15:
                  break;
                case 1:
                  if (Z !== null) {
                    var K = Z.memoizedProps,
                      He = Z.memoizedState,
                      z = i.stateNode,
                      S = z.getSnapshotBeforeUpdate(
                        i.elementType === i.type ? K : nn(i.type, K),
                        He,
                      );
                    z.__reactInternalSnapshotBeforeUpdate = S;
                  }
                  break;
                case 3:
                  var O = i.stateNode.containerInfo;
                  O.nodeType === 1
                    ? (O.textContent = "")
                    : O.nodeType === 9 &&
                      O.documentElement &&
                      O.removeChild(O.documentElement);
                  break;
                case 5:
                case 6:
                case 4:
                case 17:
                  break;
                default:
                  throw Error(r(163));
              }
          } catch (U) {
            Ae(i, i.return, U);
          }
          if (((t = i.sibling), t !== null)) {
            ((t.return = i.return), (Q = t));
            break;
          }
          Q = i.return;
        }
    return ((Z = Wf), (Wf = !1), Z);
  }
  function Mo(t, i, s) {
    var a = i.updateQueue;
    if (((a = a !== null ? a.lastEffect : null), a !== null)) {
      var f = (a = a.next);
      do {
        if ((f.tag & t) === t) {
          var h = f.destroy;
          ((f.destroy = void 0), h !== void 0 && Lu(i, s, h));
        }
        f = f.next;
      } while (f !== a);
    }
  }
  function qs(t, i) {
    if (
      ((i = i.updateQueue), (i = i !== null ? i.lastEffect : null), i !== null)
    ) {
      var s = (i = i.next);
      do {
        if ((s.tag & t) === t) {
          var a = s.create;
          s.destroy = a();
        }
        s = s.next;
      } while (s !== i);
    }
  }
  function Fu(t) {
    var i = t.ref;
    if (i !== null) {
      var s = t.stateNode;
      switch (t.tag) {
        case 5:
          t = s;
          break;
        default:
          t = s;
      }
      typeof i == "function" ? i(t) : (i.current = t);
    }
  }
  function qf(t) {
    var i = t.alternate;
    (i !== null && ((t.alternate = null), qf(i)),
      (t.child = null),
      (t.deletions = null),
      (t.sibling = null),
      t.tag === 5 &&
        ((i = t.stateNode),
        i !== null &&
          (delete i[yn],
          delete i[Co],
          delete i[Xa],
          delete i[a4],
          delete i[u4])),
      (t.stateNode = null),
      (t.return = null),
      (t.dependencies = null),
      (t.memoizedProps = null),
      (t.memoizedState = null),
      (t.pendingProps = null),
      (t.stateNode = null),
      (t.updateQueue = null));
  }
  function Gf(t) {
    return t.tag === 5 || t.tag === 3 || t.tag === 4;
  }
  function Qf(t) {
    e: for (;;) {
      for (; t.sibling === null;) {
        if (t.return === null || Gf(t.return)) return null;
        t = t.return;
      }
      for (
        t.sibling.return = t.return, t = t.sibling;
        t.tag !== 5 && t.tag !== 6 && t.tag !== 18;
      ) {
        if (t.flags & 2 || t.child === null || t.tag === 4) continue e;
        ((t.child.return = t), (t = t.child));
      }
      if (!(t.flags & 2)) return t.stateNode;
    }
  }
  function Au(t, i, s) {
    var a = t.tag;
    if (a === 5 || a === 6)
      ((t = t.stateNode),
        i
          ? s.nodeType === 8
            ? s.parentNode.insertBefore(t, i)
            : s.insertBefore(t, i)
          : (s.nodeType === 8
              ? ((i = s.parentNode), i.insertBefore(t, s))
              : ((i = s), i.appendChild(t)),
            (s = s._reactRootContainer),
            s != null || i.onclick !== null || (i.onclick = bs)));
    else if (a !== 4 && ((t = t.child), t !== null))
      for (Au(t, i, s), t = t.sibling; t !== null;)
        (Au(t, i, s), (t = t.sibling));
  }
  function Nu(t, i, s) {
    var a = t.tag;
    if (a === 5 || a === 6)
      ((t = t.stateNode), i ? s.insertBefore(t, i) : s.appendChild(t));
    else if (a !== 4 && ((t = t.child), t !== null))
      for (Nu(t, i, s), t = t.sibling; t !== null;)
        (Nu(t, i, s), (t = t.sibling));
  }
  var rt = null,
    rn = !1;
  function Jn(t, i, s) {
    for (s = s.child; s !== null;) (Zf(t, i, s), (s = s.sibling));
  }
  function Zf(t, i, s) {
    if (mn && typeof mn.onCommitFiberUnmount == "function")
      try {
        mn.onCommitFiberUnmount(os, s);
      } catch {}
    switch (s.tag) {
      case 5:
        mt || yr(s, i);
      case 6:
        var a = rt,
          f = rn;
        ((rt = null),
          Jn(t, i, s),
          (rt = a),
          (rn = f),
          rt !== null &&
            (rn
              ? ((t = rt),
                (s = s.stateNode),
                t.nodeType === 8
                  ? t.parentNode.removeChild(s)
                  : t.removeChild(s))
              : rt.removeChild(s.stateNode)));
        break;
      case 18:
        rt !== null &&
          (rn
            ? ((t = rt),
              (s = s.stateNode),
              t.nodeType === 8
                ? Ya(t.parentNode, s)
                : t.nodeType === 1 && Ya(t, s),
              lo(t))
            : Ya(rt, s.stateNode));
        break;
      case 4:
        ((a = rt),
          (f = rn),
          (rt = s.stateNode.containerInfo),
          (rn = !0),
          Jn(t, i, s),
          (rt = a),
          (rn = f));
        break;
      case 0:
      case 11:
      case 14:
      case 15:
        if (
          !mt &&
          ((a = s.updateQueue), a !== null && ((a = a.lastEffect), a !== null))
        ) {
          f = a = a.next;
          do {
            var h = f,
              y = h.destroy;
            ((h = h.tag),
              y !== void 0 && (h & 2 || h & 4) && Lu(s, i, y),
              (f = f.next));
          } while (f !== a);
        }
        Jn(t, i, s);
        break;
      case 1:
        if (
          !mt &&
          (yr(s, i),
          (a = s.stateNode),
          typeof a.componentWillUnmount == "function")
        )
          try {
            ((a.props = s.memoizedProps),
              (a.state = s.memoizedState),
              a.componentWillUnmount());
          } catch (w) {
            Ae(s, i, w);
          }
        Jn(t, i, s);
        break;
      case 21:
        Jn(t, i, s);
        break;
      case 22:
        s.mode & 1
          ? ((mt = (a = mt) || s.memoizedState !== null), Jn(t, i, s), (mt = a))
          : Jn(t, i, s);
        break;
      default:
        Jn(t, i, s);
    }
  }
  function Kf(t) {
    var i = t.updateQueue;
    if (i !== null) {
      t.updateQueue = null;
      var s = t.stateNode;
      (s === null && (s = t.stateNode = new S4()),
        i.forEach(function (a) {
          var f = L4.bind(null, t, a);
          s.has(a) || (s.add(a), a.then(f, f));
        }));
    }
  }
  function on(t, i) {
    var s = i.deletions;
    if (s !== null)
      for (var a = 0; a < s.length; a++) {
        var f = s[a];
        try {
          var h = t,
            y = i,
            w = y;
          e: for (; w !== null;) {
            switch (w.tag) {
              case 5:
                ((rt = w.stateNode), (rn = !1));
                break e;
              case 3:
                ((rt = w.stateNode.containerInfo), (rn = !0));
                break e;
              case 4:
                ((rt = w.stateNode.containerInfo), (rn = !0));
                break e;
            }
            w = w.return;
          }
          if (rt === null) throw Error(r(160));
          (Zf(h, y, f), (rt = null), (rn = !1));
          var k = f.alternate;
          (k !== null && (k.return = null), (f.return = null));
        } catch (M) {
          Ae(f, i, M);
        }
      }
    if (i.subtreeFlags & 12854)
      for (i = i.child; i !== null;) (Yf(i, t), (i = i.sibling));
  }
  function Yf(t, i) {
    var s = t.alternate,
      a = t.flags;
    switch (t.tag) {
      case 0:
      case 11:
      case 14:
      case 15:
        if ((on(i, t), Cn(t), a & 4)) {
          try {
            (Mo(3, t, t.return), qs(3, t));
          } catch (K) {
            Ae(t, t.return, K);
          }
          try {
            Mo(5, t, t.return);
          } catch (K) {
            Ae(t, t.return, K);
          }
        }
        break;
      case 1:
        (on(i, t), Cn(t), a & 512 && s !== null && yr(s, s.return));
        break;
      case 5:
        if (
          (on(i, t),
          Cn(t),
          a & 512 && s !== null && yr(s, s.return),
          t.flags & 32)
        ) {
          var f = t.stateNode;
          try {
            Kr(f, "");
          } catch (K) {
            Ae(t, t.return, K);
          }
        }
        if (a & 4 && ((f = t.stateNode), f != null)) {
          var h = t.memoizedProps,
            y = s !== null ? s.memoizedProps : h,
            w = t.type,
            k = t.updateQueue;
          if (((t.updateQueue = null), k !== null))
            try {
              (w === "input" &&
                h.type === "radio" &&
                h.name != null &&
                k3(f, h),
                ma(w, y));
              var M = ma(w, h);
              for (y = 0; y < k.length; y += 2) {
                var j = k[y],
                  B = k[y + 1];
                j === "style"
                  ? D3(f, B)
                  : j === "dangerouslySetInnerHTML"
                    ? M3(f, B)
                    : j === "children"
                      ? Kr(f, B)
                      : I(f, j, B, M);
              }
              switch (w) {
                case "input":
                  ca(f, h);
                  break;
                case "textarea":
                  P3(f, h);
                  break;
                case "select":
                  var A = f._wrapperState.wasMultiple;
                  f._wrapperState.wasMultiple = !!h.multiple;
                  var G = h.value;
                  G != null
                    ? Zi(f, !!h.multiple, G, !1)
                    : A !== !!h.multiple &&
                      (h.defaultValue != null
                        ? Zi(f, !!h.multiple, h.defaultValue, !0)
                        : Zi(f, !!h.multiple, h.multiple ? [] : "", !1));
              }
              f[Co] = h;
            } catch (K) {
              Ae(t, t.return, K);
            }
        }
        break;
      case 6:
        if ((on(i, t), Cn(t), a & 4)) {
          if (t.stateNode === null) throw Error(r(162));
          ((f = t.stateNode), (h = t.memoizedProps));
          try {
            f.nodeValue = h;
          } catch (K) {
            Ae(t, t.return, K);
          }
        }
        break;
      case 3:
        if (
          (on(i, t), Cn(t), a & 4 && s !== null && s.memoizedState.isDehydrated)
        )
          try {
            lo(i.containerInfo);
          } catch (K) {
            Ae(t, t.return, K);
          }
        break;
      case 4:
        (on(i, t), Cn(t));
        break;
      case 13:
        (on(i, t),
          Cn(t),
          (f = t.child),
          f.flags & 8192 &&
            ((h = f.memoizedState !== null),
            (f.stateNode.isHidden = h),
            !h ||
              (f.alternate !== null && f.alternate.memoizedState !== null) ||
              (Bu = Ue())),
          a & 4 && Kf(t));
        break;
      case 22:
        if (
          ((j = s !== null && s.memoizedState !== null),
          t.mode & 1 ? ((mt = (M = mt) || j), on(i, t), (mt = M)) : on(i, t),
          Cn(t),
          a & 8192)
        ) {
          if (
            ((M = t.memoizedState !== null),
            (t.stateNode.isHidden = M) && !j && t.mode & 1)
          )
            for (Q = t, j = t.child; j !== null;) {
              for (B = Q = j; Q !== null;) {
                switch (((A = Q), (G = A.child), A.tag)) {
                  case 0:
                  case 11:
                  case 14:
                  case 15:
                    Mo(4, A, A.return);
                    break;
                  case 1:
                    yr(A, A.return);
                    var Z = A.stateNode;
                    if (typeof Z.componentWillUnmount == "function") {
                      ((a = A), (s = A.return));
                      try {
                        ((i = a),
                          (Z.props = i.memoizedProps),
                          (Z.state = i.memoizedState),
                          Z.componentWillUnmount());
                      } catch (K) {
                        Ae(a, s, K);
                      }
                    }
                    break;
                  case 5:
                    yr(A, A.return);
                    break;
                  case 22:
                    if (A.memoizedState !== null) {
                      ed(B);
                      continue;
                    }
                }
                G !== null ? ((G.return = A), (Q = G)) : ed(B);
              }
              j = j.sibling;
            }
          e: for (j = null, B = t; ;) {
            if (B.tag === 5) {
              if (j === null) {
                j = B;
                try {
                  ((f = B.stateNode),
                    M
                      ? ((h = f.style),
                        typeof h.setProperty == "function"
                          ? h.setProperty("display", "none", "important")
                          : (h.display = "none"))
                      : ((w = B.stateNode),
                        (k = B.memoizedProps.style),
                        (y =
                          k != null && k.hasOwnProperty("display")
                            ? k.display
                            : null),
                        (w.style.display = R3("display", y))));
                } catch (K) {
                  Ae(t, t.return, K);
                }
              }
            } else if (B.tag === 6) {
              if (j === null)
                try {
                  B.stateNode.nodeValue = M ? "" : B.memoizedProps;
                } catch (K) {
                  Ae(t, t.return, K);
                }
            } else if (
              ((B.tag !== 22 && B.tag !== 23) ||
                B.memoizedState === null ||
                B === t) &&
              B.child !== null
            ) {
              ((B.child.return = B), (B = B.child));
              continue;
            }
            if (B === t) break e;
            for (; B.sibling === null;) {
              if (B.return === null || B.return === t) break e;
              (j === B && (j = null), (B = B.return));
            }
            (j === B && (j = null),
              (B.sibling.return = B.return),
              (B = B.sibling));
          }
        }
        break;
      case 19:
        (on(i, t), Cn(t), a & 4 && Kf(t));
        break;
      case 21:
        break;
      default:
        (on(i, t), Cn(t));
    }
  }
  function Cn(t) {
    var i = t.flags;
    if (i & 2) {
      try {
        e: {
          for (var s = t.return; s !== null;) {
            if (Gf(s)) {
              var a = s;
              break e;
            }
            s = s.return;
          }
          throw Error(r(160));
        }
        switch (a.tag) {
          case 5:
            var f = a.stateNode;
            a.flags & 32 && (Kr(f, ""), (a.flags &= -33));
            var h = Qf(t);
            Nu(t, h, f);
            break;
          case 3:
          case 4:
            var y = a.stateNode.containerInfo,
              w = Qf(t);
            Au(t, w, y);
            break;
          default:
            throw Error(r(161));
        }
      } catch (k) {
        Ae(t, t.return, k);
      }
      t.flags &= -3;
    }
    i & 4096 && (t.flags &= -4097);
  }
  function P4(t, i, s) {
    ((Q = t), Xf(t));
  }
  function Xf(t, i, s) {
    for (var a = (t.mode & 1) !== 0; Q !== null;) {
      var f = Q,
        h = f.child;
      if (f.tag === 22 && a) {
        var y = f.memoizedState !== null || Ws;
        if (!y) {
          var w = f.alternate,
            k = (w !== null && w.memoizedState !== null) || mt;
          w = Ws;
          var M = mt;
          if (((Ws = y), (mt = k) && !M))
            for (Q = f; Q !== null;)
              ((y = Q),
                (k = y.child),
                y.tag === 22 && y.memoizedState !== null
                  ? td(f)
                  : k !== null
                    ? ((k.return = y), (Q = k))
                    : td(f));
          for (; h !== null;) ((Q = h), Xf(h), (h = h.sibling));
          ((Q = f), (Ws = w), (mt = M));
        }
        Jf(t);
      } else
        f.subtreeFlags & 8772 && h !== null ? ((h.return = f), (Q = h)) : Jf(t);
    }
  }
  function Jf(t) {
    for (; Q !== null;) {
      var i = Q;
      if (i.flags & 8772) {
        var s = i.alternate;
        try {
          if (i.flags & 8772)
            switch (i.tag) {
              case 0:
              case 11:
              case 15:
                mt || qs(5, i);
                break;
              case 1:
                var a = i.stateNode;
                if (i.flags & 4 && !mt)
                  if (s === null) a.componentDidMount();
                  else {
                    var f =
                      i.elementType === i.type
                        ? s.memoizedProps
                        : nn(i.type, s.memoizedProps);
                    a.componentDidUpdate(
                      f,
                      s.memoizedState,
                      a.__reactInternalSnapshotBeforeUpdate,
                    );
                  }
                var h = i.updateQueue;
                h !== null && J9(i, h, a);
                break;
              case 3:
                var y = i.updateQueue;
                if (y !== null) {
                  if (((s = null), i.child !== null))
                    switch (i.child.tag) {
                      case 5:
                        s = i.child.stateNode;
                        break;
                      case 1:
                        s = i.child.stateNode;
                    }
                  J9(i, y, s);
                }
                break;
              case 5:
                var w = i.stateNode;
                if (s === null && i.flags & 4) {
                  s = w;
                  var k = i.memoizedProps;
                  switch (i.type) {
                    case "button":
                    case "input":
                    case "select":
                    case "textarea":
                      k.autoFocus && s.focus();
                      break;
                    case "img":
                      k.src && (s.src = k.src);
                  }
                }
                break;
              case 6:
                break;
              case 4:
                break;
              case 12:
                break;
              case 13:
                if (i.memoizedState === null) {
                  var M = i.alternate;
                  if (M !== null) {
                    var j = M.memoizedState;
                    if (j !== null) {
                      var B = j.dehydrated;
                      B !== null && lo(B);
                    }
                  }
                }
                break;
              case 19:
              case 17:
              case 21:
              case 22:
              case 23:
              case 25:
                break;
              default:
                throw Error(r(163));
            }
          mt || (i.flags & 512 && Fu(i));
        } catch (A) {
          Ae(i, i.return, A);
        }
      }
      if (i === t) {
        Q = null;
        break;
      }
      if (((s = i.sibling), s !== null)) {
        ((s.return = i.return), (Q = s));
        break;
      }
      Q = i.return;
    }
  }
  function ed(t) {
    for (; Q !== null;) {
      var i = Q;
      if (i === t) {
        Q = null;
        break;
      }
      var s = i.sibling;
      if (s !== null) {
        ((s.return = i.return), (Q = s));
        break;
      }
      Q = i.return;
    }
  }
  function td(t) {
    for (; Q !== null;) {
      var i = Q;
      try {
        switch (i.tag) {
          case 0:
          case 11:
          case 15:
            var s = i.return;
            try {
              qs(4, i);
            } catch (k) {
              Ae(i, s, k);
            }
            break;
          case 1:
            var a = i.stateNode;
            if (typeof a.componentDidMount == "function") {
              var f = i.return;
              try {
                a.componentDidMount();
              } catch (k) {
                Ae(i, f, k);
              }
            }
            var h = i.return;
            try {
              Fu(i);
            } catch (k) {
              Ae(i, h, k);
            }
            break;
          case 5:
            var y = i.return;
            try {
              Fu(i);
            } catch (k) {
              Ae(i, y, k);
            }
        }
      } catch (k) {
        Ae(i, i.return, k);
      }
      if (i === t) {
        Q = null;
        break;
      }
      var w = i.sibling;
      if (w !== null) {
        ((w.return = i.return), (Q = w));
        break;
      }
      Q = i.return;
    }
  }
  var z4 = Math.ceil,
    Gs = R.ReactCurrentDispatcher,
    $u = R.ReactCurrentOwner,
    Wt = R.ReactCurrentBatchConfig,
    ge = 0,
    et = null,
    Ge = null,
    ot = 0,
    Lt = 0,
    gr = Qn(0),
    Xe = 0,
    Ro = null,
    ki = 0,
    Qs = 0,
    ju = 0,
    Do = null,
    zt = null,
    Bu = 0,
    vr = 1 / 0,
    Ln = null,
    Zs = !1,
    Uu = null,
    ei = null,
    Ks = !1,
    ti = null,
    Ys = 0,
    To = 0,
    Hu = null,
    Xs = -1,
    Js = 0;
  function _t() {
    return ge & 6 ? Ue() : Xs !== -1 ? Xs : (Xs = Ue());
  }
  function ni(t) {
    return t.mode & 1
      ? ge & 2 && ot !== 0
        ? ot & -ot
        : f4.transition !== null
          ? (Js === 0 && (Js = G3()), Js)
          : ((t = ke),
            t !== 0 ||
              ((t = window.event), (t = t === void 0 ? 16 : n9(t.type))),
            t)
      : 1;
  }
  function sn(t, i, s, a) {
    if (50 < To) throw ((To = 0), (Hu = null), Error(r(185)));
    (no(t, s, a),
      (!(ge & 2) || t !== et) &&
        (t === et && (!(ge & 2) && (Qs |= s), Xe === 4 && ii(t, ot)),
        Ot(t, a),
        s === 1 &&
          ge === 0 &&
          !(i.mode & 1) &&
          ((vr = Ue() + 500), Ps && Kn())));
  }
  function Ot(t, i) {
    var s = t.callbackNode;
    f5(t, i);
    var a = as(t, t === et ? ot : 0);
    if (a === 0)
      (s !== null && V3(s), (t.callbackNode = null), (t.callbackPriority = 0));
    else if (((i = a & -a), t.callbackPriority !== i)) {
      if ((s != null && V3(s), i === 1))
        (t.tag === 0 ? c4(id.bind(null, t)) : B9(id.bind(null, t)),
          s4(function () {
            !(ge & 6) && Kn();
          }),
          (s = null));
      else {
        switch (Q3(a)) {
          case 1:
            s = _a;
            break;
          case 4:
            s = W3;
            break;
          case 16:
            s = rs;
            break;
          case 536870912:
            s = q3;
            break;
          default:
            s = rs;
        }
        s = fd(s, nd.bind(null, t));
      }
      ((t.callbackPriority = i), (t.callbackNode = s));
    }
  }
  function nd(t, i) {
    if (((Xs = -1), (Js = 0), ge & 6)) throw Error(r(327));
    var s = t.callbackNode;
    if (Cr() && t.callbackNode !== s) return null;
    var a = as(t, t === et ? ot : 0);
    if (a === 0) return null;
    if (a & 30 || a & t.expiredLanes || i) i = el(t, a);
    else {
      i = a;
      var f = ge;
      ge |= 2;
      var h = od();
      (et !== t || ot !== i) && ((Ln = null), (vr = Ue() + 500), Ei(t, i));
      do
        try {
          R4();
          break;
        } catch (w) {
          rd(t, w);
        }
      while (!0);
      (lu(),
        (Gs.current = h),
        (ge = f),
        Ge !== null ? (i = 0) : ((et = null), (ot = 0), (i = Xe)));
    }
    if (i !== 0) {
      if (
        (i === 2 && ((f = ba(t)), f !== 0 && ((a = f), (i = Vu(t, f)))),
        i === 1)
      )
        throw ((s = Ro), Ei(t, 0), ii(t, a), Ot(t, Ue()), s);
      if (i === 6) ii(t, a);
      else {
        if (
          ((f = t.current.alternate),
          !(a & 30) &&
            !O4(f) &&
            ((i = el(t, a)),
            i === 2 && ((h = ba(t)), h !== 0 && ((a = h), (i = Vu(t, h)))),
            i === 1))
        )
          throw ((s = Ro), Ei(t, 0), ii(t, a), Ot(t, Ue()), s);
        switch (((t.finishedWork = f), (t.finishedLanes = a), i)) {
          case 0:
          case 1:
            throw Error(r(345));
          case 2:
            Pi(t, zt, Ln);
            break;
          case 3:
            if (
              (ii(t, a),
              (a & 130023424) === a && ((i = Bu + 500 - Ue()), 10 < i))
            ) {
              if (as(t, 0) !== 0) break;
              if (((f = t.suspendedLanes), (f & a) !== a)) {
                (_t(), (t.pingedLanes |= t.suspendedLanes & f));
                break;
              }
              t.timeoutHandle = Ka(Pi.bind(null, t, zt, Ln), i);
              break;
            }
            Pi(t, zt, Ln);
            break;
          case 4:
            if ((ii(t, a), (a & 4194240) === a)) break;
            for (i = t.eventTimes, f = -1; 0 < a;) {
              var y = 31 - Jt(a);
              ((h = 1 << y), (y = i[y]), y > f && (f = y), (a &= ~h));
            }
            if (
              ((a = f),
              (a = Ue() - a),
              (a =
                (120 > a
                  ? 120
                  : 480 > a
                    ? 480
                    : 1080 > a
                      ? 1080
                      : 1920 > a
                        ? 1920
                        : 3e3 > a
                          ? 3e3
                          : 4320 > a
                            ? 4320
                            : 1960 * z4(a / 1960)) - a),
              10 < a)
            ) {
              t.timeoutHandle = Ka(Pi.bind(null, t, zt, Ln), a);
              break;
            }
            Pi(t, zt, Ln);
            break;
          case 5:
            Pi(t, zt, Ln);
            break;
          default:
            throw Error(r(329));
        }
      }
    }
    return (Ot(t, Ue()), t.callbackNode === s ? nd.bind(null, t) : null);
  }
  function Vu(t, i) {
    var s = Do;
    return (
      t.current.memoizedState.isDehydrated && (Ei(t, i).flags |= 256),
      (t = el(t, i)),
      t !== 2 && ((i = zt), (zt = s), i !== null && Wu(i)),
      t
    );
  }
  function Wu(t) {
    zt === null ? (zt = t) : zt.push.apply(zt, t);
  }
  function O4(t) {
    for (var i = t; ;) {
      if (i.flags & 16384) {
        var s = i.updateQueue;
        if (s !== null && ((s = s.stores), s !== null))
          for (var a = 0; a < s.length; a++) {
            var f = s[a],
              h = f.getSnapshot;
            f = f.value;
            try {
              if (!en(h(), f)) return !1;
            } catch {
              return !1;
            }
          }
      }
      if (((s = i.child), i.subtreeFlags & 16384 && s !== null))
        ((s.return = i), (i = s));
      else {
        if (i === t) break;
        for (; i.sibling === null;) {
          if (i.return === null || i.return === t) return !0;
          i = i.return;
        }
        ((i.sibling.return = i.return), (i = i.sibling));
      }
    }
    return !0;
  }
  function ii(t, i) {
    for (
      i &= ~ju,
        i &= ~Qs,
        t.suspendedLanes |= i,
        t.pingedLanes &= ~i,
        t = t.expirationTimes;
      0 < i;
    ) {
      var s = 31 - Jt(i),
        a = 1 << s;
      ((t[s] = -1), (i &= ~a));
    }
  }
  function id(t) {
    if (ge & 6) throw Error(r(327));
    Cr();
    var i = as(t, 0);
    if (!(i & 1)) return (Ot(t, Ue()), null);
    var s = el(t, i);
    if (t.tag !== 0 && s === 2) {
      var a = ba(t);
      a !== 0 && ((i = a), (s = Vu(t, a)));
    }
    if (s === 1) throw ((s = Ro), Ei(t, 0), ii(t, i), Ot(t, Ue()), s);
    if (s === 6) throw Error(r(345));
    return (
      (t.finishedWork = t.current.alternate),
      (t.finishedLanes = i),
      Pi(t, zt, Ln),
      Ot(t, Ue()),
      null
    );
  }
  function qu(t, i) {
    var s = ge;
    ge |= 1;
    try {
      return t(i);
    } finally {
      ((ge = s), ge === 0 && ((vr = Ue() + 500), Ps && Kn()));
    }
  }
  function Si(t) {
    ti !== null && ti.tag === 0 && !(ge & 6) && Cr();
    var i = ge;
    ge |= 1;
    var s = Wt.transition,
      a = ke;
    try {
      if (((Wt.transition = null), (ke = 1), t)) return t();
    } finally {
      ((ke = a), (Wt.transition = s), (ge = i), !(ge & 6) && Kn());
    }
  }
  function Gu() {
    ((Lt = gr.current), Re(gr));
  }
  function Ei(t, i) {
    ((t.finishedWork = null), (t.finishedLanes = 0));
    var s = t.timeoutHandle;
    if ((s !== -1 && ((t.timeoutHandle = -1), o4(s)), Ge !== null))
      for (s = Ge.return; s !== null;) {
        var a = s;
        switch ((nu(a), a.tag)) {
          case 1:
            ((a = a.type.childContextTypes), a != null && Ss());
            break;
          case 3:
            (pr(), Re(St), Re(dt), mu());
            break;
          case 5:
            hu(a);
            break;
          case 4:
            pr();
            break;
          case 13:
            Re(Ie);
            break;
          case 19:
            Re(Ie);
            break;
          case 10:
            au(a.type._context);
            break;
          case 22:
          case 23:
            Gu();
        }
        s = s.return;
      }
    if (
      ((et = t),
      (Ge = t = ri(t.current, null)),
      (ot = Lt = i),
      (Xe = 0),
      (Ro = null),
      (ju = Qs = ki = 0),
      (zt = Do = null),
      xi !== null)
    ) {
      for (i = 0; i < xi.length; i++)
        if (((s = xi[i]), (a = s.interleaved), a !== null)) {
          s.interleaved = null;
          var f = a.next,
            h = s.pending;
          if (h !== null) {
            var y = h.next;
            ((h.next = f), (a.next = y));
          }
          s.pending = a;
        }
      xi = null;
    }
    return t;
  }
  function rd(t, i) {
    do {
      var s = Ge;
      try {
        if ((lu(), (As.current = Bs), Ns)) {
          for (var a = Le.memoizedState; a !== null;) {
            var f = a.queue;
            (f !== null && (f.pending = null), (a = a.next));
          }
          Ns = !1;
        }
        if (
          ((bi = 0),
          (Je = Ye = Le = null),
          (So = !1),
          (Eo = 0),
          ($u.current = null),
          s === null || s.return === null)
        ) {
          ((Xe = 1), (Ro = i), (Ge = null));
          break;
        }
        e: {
          var h = t,
            y = s.return,
            w = s,
            k = i;
          if (
            ((i = ot),
            (w.flags |= 32768),
            k !== null && typeof k == "object" && typeof k.then == "function")
          ) {
            var M = k,
              j = w,
              B = j.tag;
            if (!(j.mode & 1) && (B === 0 || B === 11 || B === 15)) {
              var A = j.alternate;
              A
                ? ((j.updateQueue = A.updateQueue),
                  (j.memoizedState = A.memoizedState),
                  (j.lanes = A.lanes))
                : ((j.updateQueue = null), (j.memoizedState = null));
            }
            var G = Of(y);
            if (G !== null) {
              ((G.flags &= -257),
                Mf(G, y, w, h, i),
                G.mode & 1 && zf(h, M, i),
                (i = G),
                (k = M));
              var Z = i.updateQueue;
              if (Z === null) {
                var K = new Set();
                (K.add(k), (i.updateQueue = K));
              } else Z.add(k);
              break e;
            } else {
              if (!(i & 1)) {
                (zf(h, M, i), Qu());
                break e;
              }
              k = Error(r(426));
            }
          } else if (Te && w.mode & 1) {
            var He = Of(y);
            if (He !== null) {
              (!(He.flags & 65536) && (He.flags |= 256),
                Mf(He, y, w, h, i),
                ou(mr(k, w)));
              break e;
            }
          }
          ((h = k = mr(k, w)),
            Xe !== 4 && (Xe = 2),
            Do === null ? (Do = [h]) : Do.push(h),
            (h = y));
          do {
            switch (h.tag) {
              case 3:
                ((h.flags |= 65536), (i &= -i), (h.lanes |= i));
                var z = Ef(h, k, i);
                X9(h, z);
                break e;
              case 1:
                w = k;
                var S = h.type,
                  O = h.stateNode;
                if (
                  !(h.flags & 128) &&
                  (typeof S.getDerivedStateFromError == "function" ||
                    (O !== null &&
                      typeof O.componentDidCatch == "function" &&
                      (ei === null || !ei.has(O))))
                ) {
                  ((h.flags |= 65536), (i &= -i), (h.lanes |= i));
                  var U = Pf(h, w, i);
                  X9(h, U);
                  break e;
                }
            }
            h = h.return;
          } while (h !== null);
        }
        ld(s);
      } catch (Y) {
        ((i = Y), Ge === s && s !== null && (Ge = s = s.return));
        continue;
      }
      break;
    } while (!0);
  }
  function od() {
    var t = Gs.current;
    return ((Gs.current = Bs), t === null ? Bs : t);
  }
  function Qu() {
    ((Xe === 0 || Xe === 3 || Xe === 2) && (Xe = 4),
      et === null || (!(ki & 268435455) && !(Qs & 268435455)) || ii(et, ot));
  }
  function el(t, i) {
    var s = ge;
    ge |= 2;
    var a = od();
    (et !== t || ot !== i) && ((Ln = null), Ei(t, i));
    do
      try {
        M4();
        break;
      } catch (f) {
        rd(t, f);
      }
    while (!0);
    if ((lu(), (ge = s), (Gs.current = a), Ge !== null)) throw Error(r(261));
    return ((et = null), (ot = 0), Xe);
  }
  function M4() {
    for (; Ge !== null;) sd(Ge);
  }
  function R4() {
    for (; Ge !== null && !n5();) sd(Ge);
  }
  function sd(t) {
    var i = cd(t.alternate, t, Lt);
    ((t.memoizedProps = t.pendingProps),
      i === null ? ld(t) : (Ge = i),
      ($u.current = null));
  }
  function ld(t) {
    var i = t;
    do {
      var s = i.alternate;
      if (((t = i.return), i.flags & 32768)) {
        if (((s = k4(s, i)), s !== null)) {
          ((s.flags &= 32767), (Ge = s));
          return;
        }
        if (t !== null)
          ((t.flags |= 32768), (t.subtreeFlags = 0), (t.deletions = null));
        else {
          ((Xe = 6), (Ge = null));
          return;
        }
      } else if (((s = b4(s, i, Lt)), s !== null)) {
        Ge = s;
        return;
      }
      if (((i = i.sibling), i !== null)) {
        Ge = i;
        return;
      }
      Ge = i = t;
    } while (i !== null);
    Xe === 0 && (Xe = 5);
  }
  function Pi(t, i, s) {
    var a = ke,
      f = Wt.transition;
    try {
      ((Wt.transition = null), (ke = 1), D4(t, i, s, a));
    } finally {
      ((Wt.transition = f), (ke = a));
    }
    return null;
  }
  function D4(t, i, s, a) {
    do Cr();
    while (ti !== null);
    if (ge & 6) throw Error(r(327));
    s = t.finishedWork;
    var f = t.finishedLanes;
    if (s === null) return null;
    if (((t.finishedWork = null), (t.finishedLanes = 0), s === t.current))
      throw Error(r(177));
    ((t.callbackNode = null), (t.callbackPriority = 0));
    var h = s.lanes | s.childLanes;
    if (
      (d5(t, h),
      t === et && ((Ge = et = null), (ot = 0)),
      (!(s.subtreeFlags & 2064) && !(s.flags & 2064)) ||
        Ks ||
        ((Ks = !0),
        fd(rs, function () {
          return (Cr(), null);
        })),
      (h = (s.flags & 15990) !== 0),
      s.subtreeFlags & 15990 || h)
    ) {
      ((h = Wt.transition), (Wt.transition = null));
      var y = ke;
      ke = 1;
      var w = ge;
      ((ge |= 4),
        ($u.current = null),
        E4(t, s),
        Yf(s, t),
        X5(Qa),
        (fs = !!Ga),
        (Qa = Ga = null),
        (t.current = s),
        P4(s),
        i5(),
        (ge = w),
        (ke = y),
        (Wt.transition = h));
    } else t.current = s;
    if (
      (Ks && ((Ks = !1), (ti = t), (Ys = f)),
      (h = t.pendingLanes),
      h === 0 && (ei = null),
      s5(s.stateNode),
      Ot(t, Ue()),
      i !== null)
    )
      for (a = t.onRecoverableError, s = 0; s < i.length; s++)
        ((f = i[s]), a(f.value, { componentStack: f.stack, digest: f.digest }));
    if (Zs) throw ((Zs = !1), (t = Uu), (Uu = null), t);
    return (
      Ys & 1 && t.tag !== 0 && Cr(),
      (h = t.pendingLanes),
      h & 1 ? (t === Hu ? To++ : ((To = 0), (Hu = t))) : (To = 0),
      Kn(),
      null
    );
  }
  function Cr() {
    if (ti !== null) {
      var t = Q3(Ys),
        i = Wt.transition,
        s = ke;
      try {
        if (((Wt.transition = null), (ke = 16 > t ? 16 : t), ti === null))
          var a = !1;
        else {
          if (((t = ti), (ti = null), (Ys = 0), ge & 6)) throw Error(r(331));
          var f = ge;
          for (ge |= 4, Q = t.current; Q !== null;) {
            var h = Q,
              y = h.child;
            if (Q.flags & 16) {
              var w = h.deletions;
              if (w !== null) {
                for (var k = 0; k < w.length; k++) {
                  var M = w[k];
                  for (Q = M; Q !== null;) {
                    var j = Q;
                    switch (j.tag) {
                      case 0:
                      case 11:
                      case 15:
                        Mo(8, j, h);
                    }
                    var B = j.child;
                    if (B !== null) ((B.return = j), (Q = B));
                    else
                      for (; Q !== null;) {
                        j = Q;
                        var A = j.sibling,
                          G = j.return;
                        if ((qf(j), j === M)) {
                          Q = null;
                          break;
                        }
                        if (A !== null) {
                          ((A.return = G), (Q = A));
                          break;
                        }
                        Q = G;
                      }
                  }
                }
                var Z = h.alternate;
                if (Z !== null) {
                  var K = Z.child;
                  if (K !== null) {
                    Z.child = null;
                    do {
                      var He = K.sibling;
                      ((K.sibling = null), (K = He));
                    } while (K !== null);
                  }
                }
                Q = h;
              }
            }
            if (h.subtreeFlags & 2064 && y !== null) ((y.return = h), (Q = y));
            else
              e: for (; Q !== null;) {
                if (((h = Q), h.flags & 2048))
                  switch (h.tag) {
                    case 0:
                    case 11:
                    case 15:
                      Mo(9, h, h.return);
                  }
                var z = h.sibling;
                if (z !== null) {
                  ((z.return = h.return), (Q = z));
                  break e;
                }
                Q = h.return;
              }
          }
          var S = t.current;
          for (Q = S; Q !== null;) {
            y = Q;
            var O = y.child;
            if (y.subtreeFlags & 2064 && O !== null) ((O.return = y), (Q = O));
            else
              e: for (y = S; Q !== null;) {
                if (((w = Q), w.flags & 2048))
                  try {
                    switch (w.tag) {
                      case 0:
                      case 11:
                      case 15:
                        qs(9, w);
                    }
                  } catch (Y) {
                    Ae(w, w.return, Y);
                  }
                if (w === y) {
                  Q = null;
                  break e;
                }
                var U = w.sibling;
                if (U !== null) {
                  ((U.return = w.return), (Q = U));
                  break e;
                }
                Q = w.return;
              }
          }
          if (
            ((ge = f),
            Kn(),
            mn && typeof mn.onPostCommitFiberRoot == "function")
          )
            try {
              mn.onPostCommitFiberRoot(os, t);
            } catch {}
          a = !0;
        }
        return a;
      } finally {
        ((ke = s), (Wt.transition = i));
      }
    }
    return !1;
  }
  function ad(t, i, s) {
    ((i = mr(s, i)),
      (i = Ef(t, i, 1)),
      (t = Xn(t, i, 1)),
      (i = _t()),
      t !== null && (no(t, 1, i), Ot(t, i)));
  }
  function Ae(t, i, s) {
    if (t.tag === 3) ad(t, t, s);
    else
      for (; i !== null;) {
        if (i.tag === 3) {
          ad(i, t, s);
          break;
        } else if (i.tag === 1) {
          var a = i.stateNode;
          if (
            typeof i.type.getDerivedStateFromError == "function" ||
            (typeof a.componentDidCatch == "function" &&
              (ei === null || !ei.has(a)))
          ) {
            ((t = mr(s, t)),
              (t = Pf(i, t, 1)),
              (i = Xn(i, t, 1)),
              (t = _t()),
              i !== null && (no(i, 1, t), Ot(i, t)));
            break;
          }
        }
        i = i.return;
      }
  }
  function T4(t, i, s) {
    var a = t.pingCache;
    (a !== null && a.delete(i),
      (i = _t()),
      (t.pingedLanes |= t.suspendedLanes & s),
      et === t &&
        (ot & s) === s &&
        (Xe === 4 || (Xe === 3 && (ot & 130023424) === ot && 500 > Ue() - Bu)
          ? Ei(t, 0)
          : (ju |= s)),
      Ot(t, i));
  }
  function ud(t, i) {
    i === 0 &&
      (t.mode & 1
        ? ((i = ls), (ls <<= 1), !(ls & 130023424) && (ls = 4194304))
        : (i = 1));
    var s = _t();
    ((t = Dn(t, i)), t !== null && (no(t, i, s), Ot(t, s)));
  }
  function I4(t) {
    var i = t.memoizedState,
      s = 0;
    (i !== null && (s = i.retryLane), ud(t, s));
  }
  function L4(t, i) {
    var s = 0;
    switch (t.tag) {
      case 13:
        var a = t.stateNode,
          f = t.memoizedState;
        f !== null && (s = f.retryLane);
        break;
      case 19:
        a = t.stateNode;
        break;
      default:
        throw Error(r(314));
    }
    (a !== null && a.delete(i), ud(t, s));
  }
  var cd;
  cd = function (t, i, s) {
    if (t !== null)
      if (t.memoizedProps !== i.pendingProps || St.current) Pt = !0;
      else {
        if (!(t.lanes & s) && !(i.flags & 128)) return ((Pt = !1), _4(t, i, s));
        Pt = !!(t.flags & 131072);
      }
    else ((Pt = !1), Te && i.flags & 1048576 && U9(i, Os, i.index));
    switch (((i.lanes = 0), i.tag)) {
      case 2:
        var a = i.type;
        (Vs(t, i), (t = i.pendingProps));
        var f = lr(i, dt.current);
        (hr(i, s), (f = vu(null, i, a, t, f, s)));
        var h = Cu();
        return (
          (i.flags |= 1),
          typeof f == "object" &&
          f !== null &&
          typeof f.render == "function" &&
          f.$$typeof === void 0
            ? ((i.tag = 1),
              (i.memoizedState = null),
              (i.updateQueue = null),
              Et(a) ? ((h = !0), Es(i)) : (h = !1),
              (i.memoizedState =
                f.state !== null && f.state !== void 0 ? f.state : null),
              fu(i),
              (f.updater = Us),
              (i.stateNode = f),
              (f._reactInternals = i),
              Su(i, a, t, s),
              (i = Ou(null, i, a, !0, h, s)))
            : ((i.tag = 0), Te && h && tu(i), xt(null, i, f, s), (i = i.child)),
          i
        );
      case 16:
        a = i.elementType;
        e: {
          switch (
            (Vs(t, i),
            (t = i.pendingProps),
            (f = a._init),
            (a = f(a._payload)),
            (i.type = a),
            (f = i.tag = A4(a)),
            (t = nn(a, t)),
            f)
          ) {
            case 0:
              i = zu(null, i, a, t, s);
              break e;
            case 1:
              i = Ff(null, i, a, t, s);
              break e;
            case 11:
              i = Rf(null, i, a, t, s);
              break e;
            case 14:
              i = Df(null, i, a, nn(a.type, t), s);
              break e;
          }
          throw Error(r(306, a, ""));
        }
        return i;
      case 0:
        return (
          (a = i.type),
          (f = i.pendingProps),
          (f = i.elementType === a ? f : nn(a, f)),
          zu(t, i, a, f, s)
        );
      case 1:
        return (
          (a = i.type),
          (f = i.pendingProps),
          (f = i.elementType === a ? f : nn(a, f)),
          Ff(t, i, a, f, s)
        );
      case 3:
        e: {
          if ((Af(i), t === null)) throw Error(r(387));
          ((a = i.pendingProps),
            (h = i.memoizedState),
            (f = h.element),
            Y9(t, i),
            Ls(i, a, null, s));
          var y = i.memoizedState;
          if (((a = y.element), h.isDehydrated))
            if (
              ((h = {
                element: a,
                isDehydrated: !1,
                cache: y.cache,
                pendingSuspenseBoundaries: y.pendingSuspenseBoundaries,
                transitions: y.transitions,
              }),
              (i.updateQueue.baseState = h),
              (i.memoizedState = h),
              i.flags & 256)
            ) {
              ((f = mr(Error(r(423)), i)), (i = Nf(t, i, a, s, f)));
              break e;
            } else if (a !== f) {
              ((f = mr(Error(r(424)), i)), (i = Nf(t, i, a, s, f)));
              break e;
            } else
              for (
                It = Gn(i.stateNode.containerInfo.firstChild),
                  Tt = i,
                  Te = !0,
                  tn = null,
                  s = Z9(i, null, a, s),
                  i.child = s;
                s;
              )
                ((s.flags = (s.flags & -3) | 4096), (s = s.sibling));
          else {
            if ((cr(), a === f)) {
              i = In(t, i, s);
              break e;
            }
            xt(t, i, a, s);
          }
          i = i.child;
        }
        return i;
      case 5:
        return (
          ef(i),
          t === null && ru(i),
          (a = i.type),
          (f = i.pendingProps),
          (h = t !== null ? t.memoizedProps : null),
          (y = f.children),
          Za(a, f) ? (y = null) : h !== null && Za(a, h) && (i.flags |= 32),
          Lf(t, i),
          xt(t, i, y, s),
          i.child
        );
      case 6:
        return (t === null && ru(i), null);
      case 13:
        return $f(t, i, s);
      case 4:
        return (
          du(i, i.stateNode.containerInfo),
          (a = i.pendingProps),
          t === null ? (i.child = fr(i, null, a, s)) : xt(t, i, a, s),
          i.child
        );
      case 11:
        return (
          (a = i.type),
          (f = i.pendingProps),
          (f = i.elementType === a ? f : nn(a, f)),
          Rf(t, i, a, f, s)
        );
      case 7:
        return (xt(t, i, i.pendingProps, s), i.child);
      case 8:
        return (xt(t, i, i.pendingProps.children, s), i.child);
      case 12:
        return (xt(t, i, i.pendingProps.children, s), i.child);
      case 10:
        e: {
          if (
            ((a = i.type._context),
            (f = i.pendingProps),
            (h = i.memoizedProps),
            (y = f.value),
            Pe(Ds, a._currentValue),
            (a._currentValue = y),
            h !== null)
          )
            if (en(h.value, y)) {
              if (h.children === f.children && !St.current) {
                i = In(t, i, s);
                break e;
              }
            } else
              for (h = i.child, h !== null && (h.return = i); h !== null;) {
                var w = h.dependencies;
                if (w !== null) {
                  y = h.child;
                  for (var k = w.firstContext; k !== null;) {
                    if (k.context === a) {
                      if (h.tag === 1) {
                        ((k = Tn(-1, s & -s)), (k.tag = 2));
                        var M = h.updateQueue;
                        if (M !== null) {
                          M = M.shared;
                          var j = M.pending;
                          (j === null
                            ? (k.next = k)
                            : ((k.next = j.next), (j.next = k)),
                            (M.pending = k));
                        }
                      }
                      ((h.lanes |= s),
                        (k = h.alternate),
                        k !== null && (k.lanes |= s),
                        uu(h.return, s, i),
                        (w.lanes |= s));
                      break;
                    }
                    k = k.next;
                  }
                } else if (h.tag === 10) y = h.type === i.type ? null : h.child;
                else if (h.tag === 18) {
                  if (((y = h.return), y === null)) throw Error(r(341));
                  ((y.lanes |= s),
                    (w = y.alternate),
                    w !== null && (w.lanes |= s),
                    uu(y, s, i),
                    (y = h.sibling));
                } else y = h.child;
                if (y !== null) y.return = h;
                else
                  for (y = h; y !== null;) {
                    if (y === i) {
                      y = null;
                      break;
                    }
                    if (((h = y.sibling), h !== null)) {
                      ((h.return = y.return), (y = h));
                      break;
                    }
                    y = y.return;
                  }
                h = y;
              }
          (xt(t, i, f.children, s), (i = i.child));
        }
        return i;
      case 9:
        return (
          (f = i.type),
          (a = i.pendingProps.children),
          hr(i, s),
          (f = Ht(f)),
          (a = a(f)),
          (i.flags |= 1),
          xt(t, i, a, s),
          i.child
        );
      case 14:
        return (
          (a = i.type),
          (f = nn(a, i.pendingProps)),
          (f = nn(a.type, f)),
          Df(t, i, a, f, s)
        );
      case 15:
        return Tf(t, i, i.type, i.pendingProps, s);
      case 17:
        return (
          (a = i.type),
          (f = i.pendingProps),
          (f = i.elementType === a ? f : nn(a, f)),
          Vs(t, i),
          (i.tag = 1),
          Et(a) ? ((t = !0), Es(i)) : (t = !1),
          hr(i, s),
          kf(i, a, f),
          Su(i, a, f, s),
          Ou(null, i, a, !0, t, s)
        );
      case 19:
        return Bf(t, i, s);
      case 22:
        return If(t, i, s);
    }
    throw Error(r(156, i.tag));
  };
  function fd(t, i) {
    return H3(t, i);
  }
  function F4(t, i, s, a) {
    ((this.tag = t),
      (this.key = s),
      (this.sibling =
        this.child =
        this.return =
        this.stateNode =
        this.type =
        this.elementType =
          null),
      (this.index = 0),
      (this.ref = null),
      (this.pendingProps = i),
      (this.dependencies =
        this.memoizedState =
        this.updateQueue =
        this.memoizedProps =
          null),
      (this.mode = a),
      (this.subtreeFlags = this.flags = 0),
      (this.deletions = null),
      (this.childLanes = this.lanes = 0),
      (this.alternate = null));
  }
  function qt(t, i, s, a) {
    return new F4(t, i, s, a);
  }
  function Zu(t) {
    return ((t = t.prototype), !(!t || !t.isReactComponent));
  }
  function A4(t) {
    if (typeof t == "function") return Zu(t) ? 1 : 0;
    if (t != null) {
      if (((t = t.$$typeof), t === We)) return 11;
      if (t === qe) return 14;
    }
    return 2;
  }
  function ri(t, i) {
    var s = t.alternate;
    return (
      s === null
        ? ((s = qt(t.tag, i, t.key, t.mode)),
          (s.elementType = t.elementType),
          (s.type = t.type),
          (s.stateNode = t.stateNode),
          (s.alternate = t),
          (t.alternate = s))
        : ((s.pendingProps = i),
          (s.type = t.type),
          (s.flags = 0),
          (s.subtreeFlags = 0),
          (s.deletions = null)),
      (s.flags = t.flags & 14680064),
      (s.childLanes = t.childLanes),
      (s.lanes = t.lanes),
      (s.child = t.child),
      (s.memoizedProps = t.memoizedProps),
      (s.memoizedState = t.memoizedState),
      (s.updateQueue = t.updateQueue),
      (i = t.dependencies),
      (s.dependencies =
        i === null ? null : { lanes: i.lanes, firstContext: i.firstContext }),
      (s.sibling = t.sibling),
      (s.index = t.index),
      (s.ref = t.ref),
      s
    );
  }
  function tl(t, i, s, a, f, h) {
    var y = 2;
    if (((a = t), typeof t == "function")) Zu(t) && (y = 1);
    else if (typeof t == "string") y = 5;
    else
      e: switch (t) {
        case V:
          return zi(s.children, f, h, i);
        case ie:
          ((y = 8), (f |= 8));
          break;
        case he:
          return (
            (t = qt(12, s, i, f | 2)),
            (t.elementType = he),
            (t.lanes = h),
            t
          );
        case Be:
          return (
            (t = qt(13, s, i, f)),
            (t.elementType = Be),
            (t.lanes = h),
            t
          );
        case pe:
          return (
            (t = qt(19, s, i, f)),
            (t.elementType = pe),
            (t.lanes = h),
            t
          );
        case Ee:
          return nl(s, f, h, i);
        default:
          if (typeof t == "object" && t !== null)
            switch (t.$$typeof) {
              case _e:
                y = 10;
                break e;
              case Se:
                y = 9;
                break e;
              case We:
                y = 11;
                break e;
              case qe:
                y = 14;
                break e;
              case ft:
                ((y = 16), (a = null));
                break e;
            }
          throw Error(r(130, t == null ? t : typeof t, ""));
      }
    return (
      (i = qt(y, s, i, f)),
      (i.elementType = t),
      (i.type = a),
      (i.lanes = h),
      i
    );
  }
  function zi(t, i, s, a) {
    return ((t = qt(7, t, a, i)), (t.lanes = s), t);
  }
  function nl(t, i, s, a) {
    return (
      (t = qt(22, t, a, i)),
      (t.elementType = Ee),
      (t.lanes = s),
      (t.stateNode = { isHidden: !1 }),
      t
    );
  }
  function Ku(t, i, s) {
    return ((t = qt(6, t, null, i)), (t.lanes = s), t);
  }
  function Yu(t, i, s) {
    return (
      (i = qt(4, t.children !== null ? t.children : [], t.key, i)),
      (i.lanes = s),
      (i.stateNode = {
        containerInfo: t.containerInfo,
        pendingChildren: null,
        implementation: t.implementation,
      }),
      i
    );
  }
  function N4(t, i, s, a, f) {
    ((this.tag = i),
      (this.containerInfo = t),
      (this.finishedWork =
        this.pingCache =
        this.current =
        this.pendingChildren =
          null),
      (this.timeoutHandle = -1),
      (this.callbackNode = this.pendingContext = this.context = null),
      (this.callbackPriority = 0),
      (this.eventTimes = ka(0)),
      (this.expirationTimes = ka(-1)),
      (this.entangledLanes =
        this.finishedLanes =
        this.mutableReadLanes =
        this.expiredLanes =
        this.pingedLanes =
        this.suspendedLanes =
        this.pendingLanes =
          0),
      (this.entanglements = ka(0)),
      (this.identifierPrefix = a),
      (this.onRecoverableError = f),
      (this.mutableSourceEagerHydrationData = null));
  }
  function Xu(t, i, s, a, f, h, y, w, k) {
    return (
      (t = new N4(t, i, s, w, k)),
      i === 1 ? ((i = 1), h === !0 && (i |= 8)) : (i = 0),
      (h = qt(3, null, null, i)),
      (t.current = h),
      (h.stateNode = t),
      (h.memoizedState = {
        element: a,
        isDehydrated: s,
        cache: null,
        transitions: null,
        pendingSuspenseBoundaries: null,
      }),
      fu(h),
      t
    );
  }
  function $4(t, i, s) {
    var a =
      3 < arguments.length && arguments[3] !== void 0 ? arguments[3] : null;
    return {
      $$typeof: F,
      key: a == null ? null : "" + a,
      children: t,
      containerInfo: i,
      implementation: s,
    };
  }
  function dd(t) {
    if (!t) return Zn;
    t = t._reactInternals;
    e: {
      if (yi(t) !== t || t.tag !== 1) throw Error(r(170));
      var i = t;
      do {
        switch (i.tag) {
          case 3:
            i = i.stateNode.context;
            break e;
          case 1:
            if (Et(i.type)) {
              i = i.stateNode.__reactInternalMemoizedMergedChildContext;
              break e;
            }
        }
        i = i.return;
      } while (i !== null);
      throw Error(r(171));
    }
    if (t.tag === 1) {
      var s = t.type;
      if (Et(s)) return $9(t, s, i);
    }
    return i;
  }
  function hd(t, i, s, a, f, h, y, w, k) {
    return (
      (t = Xu(s, a, !0, t, f, h, y, w, k)),
      (t.context = dd(null)),
      (s = t.current),
      (a = _t()),
      (f = ni(s)),
      (h = Tn(a, f)),
      (h.callback = i ?? null),
      Xn(s, h, f),
      (t.current.lanes = f),
      no(t, f, a),
      Ot(t, a),
      t
    );
  }
  function il(t, i, s, a) {
    var f = i.current,
      h = _t(),
      y = ni(f);
    return (
      (s = dd(s)),
      i.context === null ? (i.context = s) : (i.pendingContext = s),
      (i = Tn(h, y)),
      (i.payload = { element: t }),
      (a = a === void 0 ? null : a),
      a !== null && (i.callback = a),
      (t = Xn(f, i, y)),
      t !== null && (sn(t, f, y, h), Is(t, f, y)),
      y
    );
  }
  function rl(t) {
    if (((t = t.current), !t.child)) return null;
    switch (t.child.tag) {
      case 5:
        return t.child.stateNode;
      default:
        return t.child.stateNode;
    }
  }
  function pd(t, i) {
    if (((t = t.memoizedState), t !== null && t.dehydrated !== null)) {
      var s = t.retryLane;
      t.retryLane = s !== 0 && s < i ? s : i;
    }
  }
  function Ju(t, i) {
    (pd(t, i), (t = t.alternate) && pd(t, i));
  }
  function j4() {
    return null;
  }
  var md =
    typeof reportError == "function"
      ? reportError
      : function (t) {
          console.error(t);
        };
  function ec(t) {
    this._internalRoot = t;
  }
  ((ol.prototype.render = ec.prototype.render =
    function (t) {
      var i = this._internalRoot;
      if (i === null) throw Error(r(409));
      il(t, i, null, null);
    }),
    (ol.prototype.unmount = ec.prototype.unmount =
      function () {
        var t = this._internalRoot;
        if (t !== null) {
          this._internalRoot = null;
          var i = t.containerInfo;
          (Si(function () {
            il(null, t, null, null);
          }),
            (i[zn] = null));
        }
      }));
  function ol(t) {
    this._internalRoot = t;
  }
  ol.prototype.unstable_scheduleHydration = function (t) {
    if (t) {
      var i = Y3();
      t = { blockedOn: null, target: t, priority: i };
      for (var s = 0; s < Vn.length && i !== 0 && i < Vn[s].priority; s++);
      (Vn.splice(s, 0, t), s === 0 && e9(t));
    }
  };
  function tc(t) {
    return !(!t || (t.nodeType !== 1 && t.nodeType !== 9 && t.nodeType !== 11));
  }
  function sl(t) {
    return !(
      !t ||
      (t.nodeType !== 1 &&
        t.nodeType !== 9 &&
        t.nodeType !== 11 &&
        (t.nodeType !== 8 || t.nodeValue !== " react-mount-point-unstable "))
    );
  }
  function yd() {}
  function B4(t, i, s, a, f) {
    if (f) {
      if (typeof a == "function") {
        var h = a;
        a = function () {
          var M = rl(y);
          h.call(M);
        };
      }
      var y = hd(i, a, t, 0, null, !1, !1, "", yd);
      return (
        (t._reactRootContainer = y),
        (t[zn] = y.current),
        go(t.nodeType === 8 ? t.parentNode : t),
        Si(),
        y
      );
    }
    for (; (f = t.lastChild);) t.removeChild(f);
    if (typeof a == "function") {
      var w = a;
      a = function () {
        var M = rl(k);
        w.call(M);
      };
    }
    var k = Xu(t, 0, !1, null, null, !1, !1, "", yd);
    return (
      (t._reactRootContainer = k),
      (t[zn] = k.current),
      go(t.nodeType === 8 ? t.parentNode : t),
      Si(function () {
        il(i, k, s, a);
      }),
      k
    );
  }
  function ll(t, i, s, a, f) {
    var h = s._reactRootContainer;
    if (h) {
      var y = h;
      if (typeof f == "function") {
        var w = f;
        f = function () {
          var k = rl(y);
          w.call(k);
        };
      }
      il(i, y, t, f);
    } else y = B4(s, i, t, f, a);
    return rl(y);
  }
  ((Z3 = function (t) {
    switch (t.tag) {
      case 3:
        var i = t.stateNode;
        if (i.current.memoizedState.isDehydrated) {
          var s = to(i.pendingLanes);
          s !== 0 &&
            (Sa(i, s | 1), Ot(i, Ue()), !(ge & 6) && ((vr = Ue() + 500), Kn()));
        }
        break;
      case 13:
        (Si(function () {
          var a = Dn(t, 1);
          if (a !== null) {
            var f = _t();
            sn(a, t, 1, f);
          }
        }),
          Ju(t, 1));
    }
  }),
    (Ea = function (t) {
      if (t.tag === 13) {
        var i = Dn(t, 134217728);
        if (i !== null) {
          var s = _t();
          sn(i, t, 134217728, s);
        }
        Ju(t, 134217728);
      }
    }),
    (K3 = function (t) {
      if (t.tag === 13) {
        var i = ni(t),
          s = Dn(t, i);
        if (s !== null) {
          var a = _t();
          sn(s, t, i, a);
        }
        Ju(t, i);
      }
    }),
    (Y3 = function () {
      return ke;
    }),
    (X3 = function (t, i) {
      var s = ke;
      try {
        return ((ke = t), i());
      } finally {
        ke = s;
      }
    }),
    (va = function (t, i, s) {
      switch (i) {
        case "input":
          if ((ca(t, s), (i = s.name), s.type === "radio" && i != null)) {
            for (s = t; s.parentNode;) s = s.parentNode;
            for (
              s = s.querySelectorAll(
                "input[name=" + JSON.stringify("" + i) + '][type="radio"]',
              ),
                i = 0;
              i < s.length;
              i++
            ) {
              var a = s[i];
              if (a !== t && a.form === t.form) {
                var f = ks(a);
                if (!f) throw Error(r(90));
                (Xt(a), ca(a, f));
              }
            }
          }
          break;
        case "textarea":
          P3(t, s);
          break;
        case "select":
          ((i = s.value), i != null && Zi(t, !!s.multiple, i, !1));
      }
    }),
    (F3 = qu),
    (A3 = Si));
  var U4 = { usingClientEntryPoint: !1, Events: [wo, or, ks, I3, L3, qu] },
    Io = {
      findFiberByHostInstance: gi,
      bundleType: 0,
      version: "18.3.1",
      rendererPackageName: "react-dom",
    },
    H4 = {
      bundleType: Io.bundleType,
      version: Io.version,
      rendererPackageName: Io.rendererPackageName,
      rendererConfig: Io.rendererConfig,
      overrideHookState: null,
      overrideHookStateDeletePath: null,
      overrideHookStateRenamePath: null,
      overrideProps: null,
      overridePropsDeletePath: null,
      overridePropsRenamePath: null,
      setErrorHandler: null,
      setSuspenseHandler: null,
      scheduleUpdate: null,
      currentDispatcherRef: R.ReactCurrentDispatcher,
      findHostInstanceByFiber: function (t) {
        return ((t = B3(t)), t === null ? null : t.stateNode);
      },
      findFiberByHostInstance: Io.findFiberByHostInstance || j4,
      findHostInstancesForRefresh: null,
      scheduleRefresh: null,
      scheduleRoot: null,
      setRefreshHandler: null,
      getCurrentFiber: null,
      reconcilerVersion: "18.3.1-next-f1338f8080-20240426",
    };
  if (typeof __REACT_DEVTOOLS_GLOBAL_HOOK__ < "u") {
    var al = __REACT_DEVTOOLS_GLOBAL_HOOK__;
    if (!al.isDisabled && al.supportsFiber)
      try {
        ((os = al.inject(H4)), (mn = al));
      } catch {}
  }
  return (
    (Mt.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED = U4),
    (Mt.createPortal = function (t, i) {
      var s =
        2 < arguments.length && arguments[2] !== void 0 ? arguments[2] : null;
      if (!tc(i)) throw Error(r(200));
      return $4(t, i, null, s);
    }),
    (Mt.createRoot = function (t, i) {
      if (!tc(t)) throw Error(r(299));
      var s = !1,
        a = "",
        f = md;
      return (
        i != null &&
          (i.unstable_strictMode === !0 && (s = !0),
          i.identifierPrefix !== void 0 && (a = i.identifierPrefix),
          i.onRecoverableError !== void 0 && (f = i.onRecoverableError)),
        (i = Xu(t, 1, !1, null, null, s, !1, a, f)),
        (t[zn] = i.current),
        go(t.nodeType === 8 ? t.parentNode : t),
        new ec(i)
      );
    }),
    (Mt.findDOMNode = function (t) {
      if (t == null) return null;
      if (t.nodeType === 1) return t;
      var i = t._reactInternals;
      if (i === void 0)
        throw typeof t.render == "function"
          ? Error(r(188))
          : ((t = Object.keys(t).join(",")), Error(r(268, t)));
      return ((t = B3(i)), (t = t === null ? null : t.stateNode), t);
    }),
    (Mt.flushSync = function (t) {
      return Si(t);
    }),
    (Mt.hydrate = function (t, i, s) {
      if (!sl(i)) throw Error(r(200));
      return ll(null, t, i, !0, s);
    }),
    (Mt.hydrateRoot = function (t, i, s) {
      if (!tc(t)) throw Error(r(405));
      var a = (s != null && s.hydratedSources) || null,
        f = !1,
        h = "",
        y = md;
      if (
        (s != null &&
          (s.unstable_strictMode === !0 && (f = !0),
          s.identifierPrefix !== void 0 && (h = s.identifierPrefix),
          s.onRecoverableError !== void 0 && (y = s.onRecoverableError)),
        (i = hd(i, null, t, 1, s ?? null, f, !1, h, y)),
        (t[zn] = i.current),
        go(t),
        a)
      )
        for (t = 0; t < a.length; t++)
          ((s = a[t]),
            (f = s._getVersion),
            (f = f(s._source)),
            i.mutableSourceEagerHydrationData == null
              ? (i.mutableSourceEagerHydrationData = [s, f])
              : i.mutableSourceEagerHydrationData.push(s, f));
      return new ol(i);
    }),
    (Mt.render = function (t, i, s) {
      if (!sl(i)) throw Error(r(200));
      return ll(null, t, i, !1, s);
    }),
    (Mt.unmountComponentAtNode = function (t) {
      if (!sl(t)) throw Error(r(40));
      return t._reactRootContainer
        ? (Si(function () {
            ll(null, null, t, !1, function () {
              ((t._reactRootContainer = null), (t[zn] = null));
            });
          }),
          !0)
        : !1;
    }),
    (Mt.unstable_batchedUpdates = qu),
    (Mt.unstable_renderSubtreeIntoContainer = function (t, i, s, a) {
      if (!sl(s)) throw Error(r(200));
      if (t == null || t._reactInternals === void 0) throw Error(r(38));
      return ll(t, i, s, !1, a);
    }),
    (Mt.version = "18.3.1-next-f1338f8080-20240426"),
    Mt
  );
}
var kd;
function Y4() {
  if (kd) return rc.exports;
  kd = 1;
  function n() {
    if (!(
      typeof __REACT_DEVTOOLS_GLOBAL_HOOK__ > "u" ||
      typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE != "function"
    ))
      try {
        __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(n);
      } catch (e) {
        console.error(e);
      }
  }
  return (n(), (rc.exports = K4()), rc.exports);
}
var Sd;
function X4() {
  if (Sd) return ul;
  Sd = 1;
  var n = Y4();
  return ((ul.createRoot = n.createRoot), (ul.hydrateRoot = n.hydrateRoot), ul);
}
var J4 = X4();
const e2 = p0(J4);
var gt = function () {
  return (
    (gt =
      Object.assign ||
      function (e) {
        for (var r, o = 1, l = arguments.length; o < l; o++) {
          r = arguments[o];
          for (var u in r)
            Object.prototype.hasOwnProperty.call(r, u) && (e[u] = r[u]);
        }
        return e;
      }),
    gt.apply(this, arguments)
  );
};
function Wo(n, e, r) {
  if (r || arguments.length === 2)
    for (var o = 0, l = e.length, u; o < l; o++)
      (u || !(o in e)) &&
        (u || (u = Array.prototype.slice.call(e, 0, o)), (u[o] = e[o]));
  return n.concat(u || Array.prototype.slice.call(e));
}
var De = "-ms-",
  Ho = "-moz-",
  be = "-webkit-",
  m0 = "comm",
  Kl = "rule",
  o3 = "decl",
  t2 = "@import",
  y0 = "@keyframes",
  n2 = "@layer",
  g0 = Math.abs,
  s3 = String.fromCharCode,
  Lc = Object.assign;
function i2(n, e) {
  return nt(n, 0) ^ 45
    ? (((((((e << 2) ^ nt(n, 0)) << 2) ^ nt(n, 1)) << 2) ^ nt(n, 2)) << 2) ^
        nt(n, 3)
    : 0;
}
function v0(n) {
  return n.trim();
}
function Fn(n, e) {
  return (n = e.exec(n)) ? n[0] : n;
}
function ue(n, e, r) {
  return n.replace(e, r);
}
function Sl(n, e, r) {
  return n.indexOf(e, r);
}
function nt(n, e) {
  return n.charCodeAt(e) | 0;
}
function Lr(n, e, r) {
  return n.slice(e, r);
}
function _n(n) {
  return n.length;
}
function C0(n) {
  return n.length;
}
function Bo(n, e) {
  return (e.push(n), n);
}
function r2(n, e) {
  return n.map(e).join("");
}
function Ed(n, e) {
  return n.filter(function (r) {
    return !Fn(r, e);
  });
}
var Yl = 1,
  Fr = 1,
  w0 = 0,
  Zt = 0,
  Qe = 0,
  Gr = "";
function Xl(n, e, r, o, l, u, c, d) {
  return {
    value: n,
    root: e,
    parent: r,
    type: o,
    props: l,
    children: u,
    line: Yl,
    column: Fr,
    length: c,
    return: "",
    siblings: d,
  };
}
function si(n, e) {
  return Lc(
    Xl("", null, null, "", null, null, 0, n.siblings),
    n,
    { length: -n.length },
    e,
  );
}
function wr(n) {
  for (; n.root;) n = si(n.root, { children: [n] });
  Bo(n, n.siblings);
}
function o2() {
  return Qe;
}
function s2() {
  return (
    (Qe = Zt > 0 ? nt(Gr, --Zt) : 0),
    Fr--,
    Qe === 10 && ((Fr = 1), Yl--),
    Qe
  );
}
function cn() {
  return (
    (Qe = Zt < w0 ? nt(Gr, Zt++) : 0),
    Fr++,
    Qe === 10 && ((Fr = 1), Yl++),
    Qe
  );
}
function Bi() {
  return nt(Gr, Zt);
}
function El() {
  return Zt;
}
function Jl(n, e) {
  return Lr(Gr, n, e);
}
function Fc(n) {
  switch (n) {
    case 0:
    case 9:
    case 10:
    case 13:
    case 32:
      return 5;
    case 33:
    case 43:
    case 44:
    case 47:
    case 62:
    case 64:
    case 126:
    case 59:
    case 123:
    case 125:
      return 4;
    case 58:
      return 3;
    case 34:
    case 39:
    case 40:
    case 91:
      return 2;
    case 41:
    case 93:
      return 1;
  }
  return 0;
}
function l2(n) {
  return ((Yl = Fr = 1), (w0 = _n((Gr = n))), (Zt = 0), []);
}
function a2(n) {
  return ((Gr = ""), n);
}
function lc(n) {
  return v0(Jl(Zt - 1, Ac(n === 91 ? n + 2 : n === 40 ? n + 1 : n)));
}
function u2(n) {
  for (; (Qe = Bi()) && Qe < 33;) cn();
  return Fc(n) > 2 || Fc(Qe) > 3 ? "" : " ";
}
function c2(n, e) {
  for (
    ;
    --e &&
    cn() &&
    !(Qe < 48 || Qe > 102 || (Qe > 57 && Qe < 65) || (Qe > 70 && Qe < 97));
  );
  return Jl(n, El() + (e < 6 && Bi() == 32 && cn() == 32));
}
function Ac(n) {
  for (; cn();)
    switch (Qe) {
      case n:
        return Zt;
      case 34:
      case 39:
        n !== 34 && n !== 39 && Ac(Qe);
        break;
      case 40:
        n === 41 && Ac(n);
        break;
      case 92:
        cn();
        break;
    }
  return Zt;
}
function f2(n, e) {
  for (; cn() && n + Qe !== 57;) if (n + Qe === 84 && Bi() === 47) break;
  return "/*" + Jl(e, Zt - 1) + "*" + s3(n === 47 ? n : cn());
}
function d2(n) {
  for (; !Fc(Bi());) cn();
  return Jl(n, Zt);
}
function h2(n) {
  return a2(Pl("", null, null, null, [""], (n = l2(n)), 0, [0], n));
}
function Pl(n, e, r, o, l, u, c, d, p) {
  for (
    var m = 0,
      g = 0,
      v = c,
      C = 0,
      x = 0,
      b = 0,
      _ = 1,
      E = 1,
      T = 1,
      D = 0,
      I = "",
      R = l,
      N = u,
      F = o,
      V = I;
    E;
  )
    switch (((b = D), (D = cn()))) {
      case 40:
        if (b != 108 && nt(V, v - 1) == 58) {
          Sl((V += ue(lc(D), "&", "&\f")), "&\f", g0(m ? d[m - 1] : 0)) != -1 &&
            (T = -1);
          break;
        }
      case 34:
      case 39:
      case 91:
        V += lc(D);
        break;
      case 9:
      case 10:
      case 13:
      case 32:
        V += u2(b);
        break;
      case 92:
        V += c2(El() - 1, 7);
        continue;
      case 47:
        switch (Bi()) {
          case 42:
          case 47:
            Bo(p2(f2(cn(), El()), e, r, p), p);
            break;
          default:
            V += "/";
        }
        break;
      case 123 * _:
        d[m++] = _n(V) * T;
      case 125 * _:
      case 59:
      case 0:
        switch (D) {
          case 0:
          case 125:
            E = 0;
          case 59 + g:
            (T == -1 && (V = ue(V, /\f/g, "")),
              x > 0 &&
                _n(V) - v &&
                Bo(
                  x > 32
                    ? zd(V + ";", o, r, v - 1, p)
                    : zd(ue(V, " ", "") + ";", o, r, v - 2, p),
                  p,
                ));
            break;
          case 59:
            V += ";";
          default:
            if (
              (Bo(
                (F = Pd(V, e, r, m, g, l, d, I, (R = []), (N = []), v, u)),
                u,
              ),
              D === 123)
            )
              if (g === 0) Pl(V, e, F, F, R, u, v, d, N);
              else
                switch (C === 99 && nt(V, 3) === 110 ? 100 : C) {
                  case 100:
                  case 108:
                  case 109:
                  case 115:
                    Pl(
                      n,
                      F,
                      F,
                      o && Bo(Pd(n, F, F, 0, 0, l, d, I, l, (R = []), v, N), N),
                      l,
                      N,
                      v,
                      d,
                      o ? R : N,
                    );
                    break;
                  default:
                    Pl(V, F, F, F, [""], N, 0, d, N);
                }
        }
        ((m = g = x = 0), (_ = T = 1), (I = V = ""), (v = c));
        break;
      case 58:
        ((v = 1 + _n(V)), (x = b));
      default:
        if (_ < 1) {
          if (D == 123) --_;
          else if (D == 125 && _++ == 0 && s2() == 125) continue;
        }
        switch (((V += s3(D)), D * _)) {
          case 38:
            T = g > 0 ? 1 : ((V += "\f"), -1);
            break;
          case 44:
            ((d[m++] = (_n(V) - 1) * T), (T = 1));
            break;
          case 64:
            (Bi() === 45 && (V += lc(cn())),
              (C = Bi()),
              (g = v = _n((I = V += d2(El())))),
              D++);
            break;
          case 45:
            b === 45 && _n(V) == 2 && (_ = 0);
        }
    }
  return u;
}
function Pd(n, e, r, o, l, u, c, d, p, m, g, v) {
  for (
    var C = l - 1, x = l === 0 ? u : [""], b = C0(x), _ = 0, E = 0, T = 0;
    _ < o;
    ++_
  )
    for (var D = 0, I = Lr(n, C + 1, (C = g0((E = c[_])))), R = n; D < b; ++D)
      (R = v0(E > 0 ? x[D] + " " + I : ue(I, /&\f/g, x[D]))) && (p[T++] = R);
  return Xl(n, e, r, l === 0 ? Kl : d, p, m, g, v);
}
function p2(n, e, r, o) {
  return Xl(n, e, r, m0, s3(o2()), Lr(n, 2, -2), 0, o);
}
function zd(n, e, r, o, l) {
  return Xl(n, e, r, o3, Lr(n, 0, o), Lr(n, o + 1, -1), o, l);
}
function x0(n, e, r) {
  switch (i2(n, e)) {
    case 5103:
      return be + "print-" + n + n;
    case 5737:
    case 4201:
    case 3177:
    case 3433:
    case 1641:
    case 4457:
    case 2921:
    case 5572:
    case 6356:
    case 5844:
    case 3191:
    case 6645:
    case 3005:
    case 6391:
    case 5879:
    case 5623:
    case 6135:
    case 4599:
    case 4855:
    case 4215:
    case 6389:
    case 5109:
    case 5365:
    case 5621:
    case 3829:
      return be + n + n;
    case 4789:
      return Ho + n + n;
    case 5349:
    case 4246:
    case 4810:
    case 6968:
    case 2756:
      return be + n + Ho + n + De + n + n;
    case 5936:
      switch (nt(n, e + 11)) {
        case 114:
          return be + n + De + ue(n, /[svh]\w+-[tblr]{2}/, "tb") + n;
        case 108:
          return be + n + De + ue(n, /[svh]\w+-[tblr]{2}/, "tb-rl") + n;
        case 45:
          return be + n + De + ue(n, /[svh]\w+-[tblr]{2}/, "lr") + n;
      }
    case 6828:
    case 4268:
    case 2903:
      return be + n + De + n + n;
    case 6165:
      return be + n + De + "flex-" + n + n;
    case 5187:
      return (
        be + n + ue(n, /(\w+).+(:[^]+)/, be + "box-$1$2" + De + "flex-$1$2") + n
      );
    case 5443:
      return (
        be +
        n +
        De +
        "flex-item-" +
        ue(n, /flex-|-self/g, "") +
        (Fn(n, /flex-|baseline/)
          ? ""
          : De + "grid-row-" + ue(n, /flex-|-self/g, "")) +
        n
      );
    case 4675:
      return (
        be +
        n +
        De +
        "flex-line-pack" +
        ue(n, /align-content|flex-|-self/g, "") +
        n
      );
    case 5548:
      return be + n + De + ue(n, "shrink", "negative") + n;
    case 5292:
      return be + n + De + ue(n, "basis", "preferred-size") + n;
    case 6060:
      return (
        be +
        "box-" +
        ue(n, "-grow", "") +
        be +
        n +
        De +
        ue(n, "grow", "positive") +
        n
      );
    case 4554:
      return be + ue(n, /([^-])(transform)/g, "$1" + be + "$2") + n;
    case 6187:
      return (
        ue(
          ue(ue(n, /(zoom-|grab)/, be + "$1"), /(image-set)/, be + "$1"),
          n,
          "",
        ) + n
      );
    case 5495:
    case 3959:
      return ue(n, /(image-set\([^]*)/, be + "$1$`$1");
    case 4968:
      return (
        ue(
          ue(n, /(.+:)(flex-)?(.*)/, be + "box-pack:$3" + De + "flex-pack:$3"),
          /s.+-b[^;]+/,
          "justify",
        ) +
        be +
        n +
        n
      );
    case 4200:
      if (!Fn(n, /flex-|baseline/))
        return De + "grid-column-align" + Lr(n, e) + n;
      break;
    case 2592:
    case 3360:
      return De + ue(n, "template-", "") + n;
    case 4384:
    case 3616:
      return r &&
        r.some(function (o, l) {
          return ((e = l), Fn(o.props, /grid-\w+-end/));
        })
        ? ~Sl(n + (r = r[e].value), "span", 0)
          ? n
          : De +
            ue(n, "-start", "") +
            n +
            De +
            "grid-row-span:" +
            (~Sl(r, "span", 0) ? Fn(r, /\d+/) : +Fn(r, /\d+/) - +Fn(n, /\d+/)) +
            ";"
        : De + ue(n, "-start", "") + n;
    case 4896:
    case 4128:
      return r &&
        r.some(function (o) {
          return Fn(o.props, /grid-\w+-start/);
        })
        ? n
        : De + ue(ue(n, "-end", "-span"), "span ", "") + n;
    case 4095:
    case 3583:
    case 4068:
    case 2532:
      return ue(n, /(.+)-inline(.+)/, be + "$1$2") + n;
    case 8116:
    case 7059:
    case 5753:
    case 5535:
    case 5445:
    case 5701:
    case 4933:
    case 4677:
    case 5533:
    case 5789:
    case 5021:
    case 4765:
      if (_n(n) - 1 - e > 6)
        switch (nt(n, e + 1)) {
          case 109:
            if (nt(n, e + 4) !== 45) break;
          case 102:
            return (
              ue(
                n,
                /(.+:)(.+)-([^]+)/,
                "$1" +
                  be +
                  "$2-$3$1" +
                  Ho +
                  (nt(n, e + 3) == 108 ? "$3" : "$2-$3"),
              ) + n
            );
          case 115:
            return ~Sl(n, "stretch", 0)
              ? x0(ue(n, "stretch", "fill-available"), e, r) + n
              : n;
        }
      break;
    case 5152:
    case 5920:
      return ue(
        n,
        /(.+?):(\d+)(\s*\/\s*(span)?\s*(\d+))?(.*)/,
        function (o, l, u, c, d, p, m) {
          return (
            De +
            l +
            ":" +
            u +
            m +
            (c ? De + l + "-span:" + (d ? p : +p - +u) + m : "") +
            n
          );
        },
      );
    case 4949:
      if (nt(n, e + 6) === 121) return ue(n, ":", ":" + be) + n;
      break;
    case 6444:
      switch (nt(n, nt(n, 14) === 45 ? 18 : 11)) {
        case 120:
          return (
            ue(
              n,
              /(.+:)([^;\s!]+)(;|(\s+)?!.+)?/,
              "$1" +
                be +
                (nt(n, 14) === 45 ? "inline-" : "") +
                "box$3$1" +
                be +
                "$2$3$1" +
                De +
                "$2box$3",
            ) + n
          );
        case 100:
          return ue(n, ":", ":" + De) + n;
      }
      break;
    case 5719:
    case 2647:
    case 2135:
    case 3927:
    case 2391:
      return ue(n, "scroll-", "scroll-snap-") + n;
  }
  return n;
}
function Tl(n, e) {
  for (var r = "", o = 0; o < n.length; o++) r += e(n[o], o, n, e) || "";
  return r;
}
function m2(n, e, r, o) {
  switch (n.type) {
    case n2:
      if (n.children.length) break;
    case t2:
    case o3:
      return (n.return = n.return || n.value);
    case m0:
      return "";
    case y0:
      return (n.return = n.value + "{" + Tl(n.children, o) + "}");
    case Kl:
      if (!_n((n.value = n.props.join(",")))) return "";
  }
  return _n((r = Tl(n.children, o)))
    ? (n.return = n.value + "{" + r + "}")
    : "";
}
function y2(n) {
  var e = C0(n);
  return function (r, o, l, u) {
    for (var c = "", d = 0; d < e; d++) c += n[d](r, o, l, u) || "";
    return c;
  };
}
function g2(n) {
  return function (e) {
    e.root || ((e = e.return) && n(e));
  };
}
function v2(n, e, r, o) {
  if (n.length > -1 && !n.return)
    switch (n.type) {
      case o3:
        n.return = x0(n.value, n.length, r);
        return;
      case y0:
        return Tl([si(n, { value: ue(n.value, "@", "@" + be) })], o);
      case Kl:
        if (n.length)
          return r2((r = n.props), function (l) {
            switch (Fn(l, (o = /(::plac\w+|:read-\w+)/))) {
              case ":read-only":
              case ":read-write":
                (wr(si(n, { props: [ue(l, /:(read-\w+)/, ":" + Ho + "$1")] })),
                  wr(si(n, { props: [l] })),
                  Lc(n, { props: Ed(r, o) }));
                break;
              case "::placeholder":
                (wr(
                  si(n, {
                    props: [ue(l, /:(plac\w+)/, ":" + be + "input-$1")],
                  }),
                ),
                  wr(si(n, { props: [ue(l, /:(plac\w+)/, ":" + Ho + "$1")] })),
                  wr(si(n, { props: [ue(l, /:(plac\w+)/, De + "input-$1")] })),
                  wr(si(n, { props: [l] })),
                  Lc(n, { props: Ed(r, o) }));
                break;
            }
            return "";
          });
    }
}
var C2 = {
    animationIterationCount: 1,
    aspectRatio: 1,
    borderImageOutset: 1,
    borderImageSlice: 1,
    borderImageWidth: 1,
    boxFlex: 1,
    boxFlexGroup: 1,
    boxOrdinalGroup: 1,
    columnCount: 1,
    columns: 1,
    flex: 1,
    flexGrow: 1,
    flexPositive: 1,
    flexShrink: 1,
    flexNegative: 1,
    flexOrder: 1,
    gridRow: 1,
    gridRowEnd: 1,
    gridRowSpan: 1,
    gridRowStart: 1,
    gridColumn: 1,
    gridColumnEnd: 1,
    gridColumnSpan: 1,
    gridColumnStart: 1,
    msGridRow: 1,
    msGridRowSpan: 1,
    msGridColumn: 1,
    msGridColumnSpan: 1,
    fontWeight: 1,
    lineHeight: 1,
    opacity: 1,
    order: 1,
    orphans: 1,
    tabSize: 1,
    widows: 1,
    zIndex: 1,
    zoom: 1,
    WebkitLineClamp: 1,
    fillOpacity: 1,
    floodOpacity: 1,
    stopOpacity: 1,
    strokeDasharray: 1,
    strokeDashoffset: 1,
    strokeMiterlimit: 1,
    strokeOpacity: 1,
    strokeWidth: 1,
  },
  Ft = {},
  Ar =
    (typeof process < "u" &&
      Ft !== void 0 &&
      (Ft.REACT_APP_SC_ATTR || Ft.SC_ATTR)) ||
    "data-styled",
  _0 = "active",
  b0 = "data-styled-version",
  ea = "6.1.13",
  l3 = `/*!sc*/
`,
  Il = typeof window < "u" && "HTMLElement" in window,
  w2 = !!(typeof SC_DISABLE_SPEEDY == "boolean"
    ? SC_DISABLE_SPEEDY
    : typeof process < "u" &&
        Ft !== void 0 &&
        Ft.REACT_APP_SC_DISABLE_SPEEDY !== void 0 &&
        Ft.REACT_APP_SC_DISABLE_SPEEDY !== ""
      ? Ft.REACT_APP_SC_DISABLE_SPEEDY !== "false" &&
        Ft.REACT_APP_SC_DISABLE_SPEEDY
      : typeof process < "u" &&
        Ft !== void 0 &&
        Ft.SC_DISABLE_SPEEDY !== void 0 &&
        Ft.SC_DISABLE_SPEEDY !== "" &&
        Ft.SC_DISABLE_SPEEDY !== "false" &&
        Ft.SC_DISABLE_SPEEDY),
  x2 = {},
  ta = Object.freeze([]),
  Nr = Object.freeze({});
function k0(n, e, r) {
  return (
    r === void 0 && (r = Nr),
    (n.theme !== r.theme && n.theme) || e || r.theme
  );
}
var S0 = new Set([
    "a",
    "abbr",
    "address",
    "area",
    "article",
    "aside",
    "audio",
    "b",
    "base",
    "bdi",
    "bdo",
    "big",
    "blockquote",
    "body",
    "br",
    "button",
    "canvas",
    "caption",
    "cite",
    "code",
    "col",
    "colgroup",
    "data",
    "datalist",
    "dd",
    "del",
    "details",
    "dfn",
    "dialog",
    "div",
    "dl",
    "dt",
    "em",
    "embed",
    "fieldset",
    "figcaption",
    "figure",
    "footer",
    "form",
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "header",
    "hgroup",
    "hr",
    "html",
    "i",
    "iframe",
    "img",
    "input",
    "ins",
    "kbd",
    "keygen",
    "label",
    "legend",
    "li",
    "link",
    "main",
    "map",
    "mark",
    "menu",
    "menuitem",
    "meta",
    "meter",
    "nav",
    "noscript",
    "object",
    "ol",
    "optgroup",
    "option",
    "output",
    "p",
    "param",
    "picture",
    "pre",
    "progress",
    "q",
    "rp",
    "rt",
    "ruby",
    "s",
    "samp",
    "script",
    "section",
    "select",
    "small",
    "source",
    "span",
    "strong",
    "style",
    "sub",
    "summary",
    "sup",
    "table",
    "tbody",
    "td",
    "textarea",
    "tfoot",
    "th",
    "thead",
    "time",
    "tr",
    "track",
    "u",
    "ul",
    "use",
    "var",
    "video",
    "wbr",
    "circle",
    "clipPath",
    "defs",
    "ellipse",
    "foreignObject",
    "g",
    "image",
    "line",
    "linearGradient",
    "marker",
    "mask",
    "path",
    "pattern",
    "polygon",
    "polyline",
    "radialGradient",
    "rect",
    "stop",
    "svg",
    "text",
    "tspan",
  ]),
  _2 = /[!"#$%&'()*+,./:;<=>?@[\\\]^`{|}~-]+/g,
  b2 = /(^-|-$)/g;
function Od(n) {
  return n.replace(_2, "-").replace(b2, "");
}
var k2 = /(a)(d)/gi,
  cl = 52,
  Md = function (n) {
    return String.fromCharCode(n + (n > 25 ? 39 : 97));
  };
function Nc(n) {
  var e,
    r = "";
  for (e = Math.abs(n); e > cl; e = (e / cl) | 0) r = Md(e % cl) + r;
  return (Md(e % cl) + r).replace(k2, "$1-$2");
}
var ac,
  E0 = 5381,
  Sr = function (n, e) {
    for (var r = e.length; r;) n = (33 * n) ^ e.charCodeAt(--r);
    return n;
  },
  P0 = function (n) {
    return Sr(E0, n);
  };
function z0(n) {
  return Nc(P0(n) >>> 0);
}
function S2(n) {
  return n.displayName || n.name || "Component";
}
function uc(n) {
  return typeof n == "string" && !0;
}
var O0 = typeof Symbol == "function" && Symbol.for,
  M0 = O0 ? Symbol.for("react.memo") : 60115,
  E2 = O0 ? Symbol.for("react.forward_ref") : 60112,
  P2 = {
    childContextTypes: !0,
    contextType: !0,
    contextTypes: !0,
    defaultProps: !0,
    displayName: !0,
    getDefaultProps: !0,
    getDerivedStateFromError: !0,
    getDerivedStateFromProps: !0,
    mixins: !0,
    propTypes: !0,
    type: !0,
  },
  z2 = {
    name: !0,
    length: !0,
    prototype: !0,
    caller: !0,
    callee: !0,
    arguments: !0,
    arity: !0,
  },
  R0 = {
    $$typeof: !0,
    compare: !0,
    defaultProps: !0,
    displayName: !0,
    propTypes: !0,
    type: !0,
  },
  O2 =
    (((ac = {})[E2] = {
      $$typeof: !0,
      render: !0,
      defaultProps: !0,
      displayName: !0,
      propTypes: !0,
    }),
    (ac[M0] = R0),
    ac);
function Rd(n) {
  return ("type" in (e = n) && e.type.$$typeof) === M0
    ? R0
    : "$$typeof" in n
      ? O2[n.$$typeof]
      : P2;
  var e;
}
var M2 = Object.defineProperty,
  R2 = Object.getOwnPropertyNames,
  Dd = Object.getOwnPropertySymbols,
  D2 = Object.getOwnPropertyDescriptor,
  T2 = Object.getPrototypeOf,
  Td = Object.prototype;
function D0(n, e, r) {
  if (typeof e != "string") {
    if (Td) {
      var o = T2(e);
      o && o !== Td && D0(n, o, r);
    }
    var l = R2(e);
    Dd && (l = l.concat(Dd(e)));
    for (var u = Rd(n), c = Rd(e), d = 0; d < l.length; ++d) {
      var p = l[d];
      if (!(p in z2 || (r && r[p]) || (c && p in c) || (u && p in u))) {
        var m = D2(e, p);
        try {
          M2(n, p, m);
        } catch {}
      }
    }
  }
  return n;
}
function $r(n) {
  return typeof n == "function";
}
function a3(n) {
  return typeof n == "object" && "styledComponentId" in n;
}
function Li(n, e) {
  return n && e ? "".concat(n, " ").concat(e) : n || e || "";
}
function $c(n, e) {
  if (n.length === 0) return "";
  for (var r = n[0], o = 1; o < n.length; o++) r += n[o];
  return r;
}
function qo(n) {
  return (
    n !== null &&
    typeof n == "object" &&
    n.constructor.name === Object.name &&
    !("props" in n && n.$$typeof)
  );
}
function jc(n, e, r) {
  if ((r === void 0 && (r = !1), !r && !qo(n) && !Array.isArray(n))) return e;
  if (Array.isArray(e))
    for (var o = 0; o < e.length; o++) n[o] = jc(n[o], e[o]);
  else if (qo(e)) for (var o in e) n[o] = jc(n[o], e[o]);
  return n;
}
function u3(n, e) {
  Object.defineProperty(n, "toString", { value: e });
}
function Ko(n) {
  for (var e = [], r = 1; r < arguments.length; r++) e[r - 1] = arguments[r];
  return new Error(
    "An error occurred. See https://github.com/styled-components/styled-components/blob/main/packages/styled-components/src/utils/errors.md#"
      .concat(n, " for more information.")
      .concat(e.length > 0 ? " Args: ".concat(e.join(", ")) : ""),
  );
}
var I2 = (function () {
    function n(e) {
      ((this.groupSizes = new Uint32Array(512)),
        (this.length = 512),
        (this.tag = e));
    }
    return (
      (n.prototype.indexOfGroup = function (e) {
        for (var r = 0, o = 0; o < e; o++) r += this.groupSizes[o];
        return r;
      }),
      (n.prototype.insertRules = function (e, r) {
        if (e >= this.groupSizes.length) {
          for (var o = this.groupSizes, l = o.length, u = l; e >= u;)
            if ((u <<= 1) < 0) throw Ko(16, "".concat(e));
          ((this.groupSizes = new Uint32Array(u)),
            this.groupSizes.set(o),
            (this.length = u));
          for (var c = l; c < u; c++) this.groupSizes[c] = 0;
        }
        for (
          var d = this.indexOfGroup(e + 1), p = ((c = 0), r.length);
          c < p;
          c++
        )
          this.tag.insertRule(d, r[c]) && (this.groupSizes[e]++, d++);
      }),
      (n.prototype.clearGroup = function (e) {
        if (e < this.length) {
          var r = this.groupSizes[e],
            o = this.indexOfGroup(e),
            l = o + r;
          this.groupSizes[e] = 0;
          for (var u = o; u < l; u++) this.tag.deleteRule(o);
        }
      }),
      (n.prototype.getGroup = function (e) {
        var r = "";
        if (e >= this.length || this.groupSizes[e] === 0) return r;
        for (
          var o = this.groupSizes[e],
            l = this.indexOfGroup(e),
            u = l + o,
            c = l;
          c < u;
          c++
        )
          r += "".concat(this.tag.getRule(c)).concat(l3);
        return r;
      }),
      n
    );
  })(),
  zl = new Map(),
  Ll = new Map(),
  Ol = 1,
  fl = function (n) {
    if (zl.has(n)) return zl.get(n);
    for (; Ll.has(Ol);) Ol++;
    var e = Ol++;
    return (zl.set(n, e), Ll.set(e, n), e);
  },
  L2 = function (n, e) {
    ((Ol = e + 1), zl.set(n, e), Ll.set(e, n));
  },
  F2 = "style[".concat(Ar, "][").concat(b0, '="').concat(ea, '"]'),
  A2 = new RegExp(
    "^".concat(Ar, '\\.g(\\d+)\\[id="([\\w\\d-]+)"\\].*?"([^"]*)'),
  ),
  N2 = function (n, e, r) {
    for (var o, l = r.split(","), u = 0, c = l.length; u < c; u++)
      (o = l[u]) && n.registerName(e, o);
  },
  $2 = function (n, e) {
    for (
      var r,
        o = ((r = e.textContent) !== null && r !== void 0 ? r : "").split(l3),
        l = [],
        u = 0,
        c = o.length;
      u < c;
      u++
    ) {
      var d = o[u].trim();
      if (d) {
        var p = d.match(A2);
        if (p) {
          var m = 0 | parseInt(p[1], 10),
            g = p[2];
          (m !== 0 && (L2(g, m), N2(n, g, p[3]), n.getTag().insertRules(m, l)),
            (l.length = 0));
        } else l.push(d);
      }
    }
  },
  Id = function (n) {
    for (
      var e = document.querySelectorAll(F2), r = 0, o = e.length;
      r < o;
      r++
    ) {
      var l = e[r];
      l &&
        l.getAttribute(Ar) !== _0 &&
        ($2(n, l), l.parentNode && l.parentNode.removeChild(l));
    }
  };
function j2() {
  return typeof __webpack_nonce__ < "u" ? __webpack_nonce__ : null;
}
var T0 = function (n) {
    var e = document.head,
      r = n || e,
      o = document.createElement("style"),
      l = (function (d) {
        var p = Array.from(d.querySelectorAll("style[".concat(Ar, "]")));
        return p[p.length - 1];
      })(r),
      u = l !== void 0 ? l.nextSibling : null;
    (o.setAttribute(Ar, _0), o.setAttribute(b0, ea));
    var c = j2();
    return (c && o.setAttribute("nonce", c), r.insertBefore(o, u), o);
  },
  B2 = (function () {
    function n(e) {
      ((this.element = T0(e)),
        this.element.appendChild(document.createTextNode("")),
        (this.sheet = (function (r) {
          if (r.sheet) return r.sheet;
          for (var o = document.styleSheets, l = 0, u = o.length; l < u; l++) {
            var c = o[l];
            if (c.ownerNode === r) return c;
          }
          throw Ko(17);
        })(this.element)),
        (this.length = 0));
    }
    return (
      (n.prototype.insertRule = function (e, r) {
        try {
          return (this.sheet.insertRule(r, e), this.length++, !0);
        } catch {
          return !1;
        }
      }),
      (n.prototype.deleteRule = function (e) {
        (this.sheet.deleteRule(e), this.length--);
      }),
      (n.prototype.getRule = function (e) {
        var r = this.sheet.cssRules[e];
        return r && r.cssText ? r.cssText : "";
      }),
      n
    );
  })(),
  U2 = (function () {
    function n(e) {
      ((this.element = T0(e)),
        (this.nodes = this.element.childNodes),
        (this.length = 0));
    }
    return (
      (n.prototype.insertRule = function (e, r) {
        if (e <= this.length && e >= 0) {
          var o = document.createTextNode(r);
          return (
            this.element.insertBefore(o, this.nodes[e] || null),
            this.length++,
            !0
          );
        }
        return !1;
      }),
      (n.prototype.deleteRule = function (e) {
        (this.element.removeChild(this.nodes[e]), this.length--);
      }),
      (n.prototype.getRule = function (e) {
        return e < this.length ? this.nodes[e].textContent : "";
      }),
      n
    );
  })(),
  H2 = (function () {
    function n(e) {
      ((this.rules = []), (this.length = 0));
    }
    return (
      (n.prototype.insertRule = function (e, r) {
        return (
          e <= this.length && (this.rules.splice(e, 0, r), this.length++, !0)
        );
      }),
      (n.prototype.deleteRule = function (e) {
        (this.rules.splice(e, 1), this.length--);
      }),
      (n.prototype.getRule = function (e) {
        return e < this.length ? this.rules[e] : "";
      }),
      n
    );
  })(),
  Ld = Il,
  V2 = { isServer: !Il, useCSSOMInjection: !w2 },
  Fl = (function () {
    function n(e, r, o) {
      (e === void 0 && (e = Nr), r === void 0 && (r = {}));
      var l = this;
      ((this.options = gt(gt({}, V2), e)),
        (this.gs = r),
        (this.names = new Map(o)),
        (this.server = !!e.isServer),
        !this.server && Il && Ld && ((Ld = !1), Id(this)),
        u3(this, function () {
          return (function (u) {
            for (
              var c = u.getTag(),
                d = c.length,
                p = "",
                m = function (v) {
                  var C = (function (T) {
                    return Ll.get(T);
                  })(v);
                  if (C === void 0) return "continue";
                  var x = u.names.get(C),
                    b = c.getGroup(v);
                  if (x === void 0 || !x.size || b.length === 0)
                    return "continue";
                  var _ = ""
                      .concat(Ar, ".g")
                      .concat(v, '[id="')
                      .concat(C, '"]'),
                    E = "";
                  (x !== void 0 &&
                    x.forEach(function (T) {
                      T.length > 0 && (E += "".concat(T, ","));
                    }),
                    (p += ""
                      .concat(b)
                      .concat(_, '{content:"')
                      .concat(E, '"}')
                      .concat(l3)));
                },
                g = 0;
              g < d;
              g++
            )
              m(g);
            return p;
          })(l);
        }));
    }
    return (
      (n.registerId = function (e) {
        return fl(e);
      }),
      (n.prototype.rehydrate = function () {
        !this.server && Il && Id(this);
      }),
      (n.prototype.reconstructWithOptions = function (e, r) {
        return (
          r === void 0 && (r = !0),
          new n(
            gt(gt({}, this.options), e),
            this.gs,
            (r && this.names) || void 0,
          )
        );
      }),
      (n.prototype.allocateGSInstance = function (e) {
        return (this.gs[e] = (this.gs[e] || 0) + 1);
      }),
      (n.prototype.getTag = function () {
        return (
          this.tag ||
          (this.tag =
            ((e = (function (r) {
              var o = r.useCSSOMInjection,
                l = r.target;
              return r.isServer ? new H2(l) : o ? new B2(l) : new U2(l);
            })(this.options)),
            new I2(e)))
        );
        var e;
      }),
      (n.prototype.hasNameForId = function (e, r) {
        return this.names.has(e) && this.names.get(e).has(r);
      }),
      (n.prototype.registerName = function (e, r) {
        if ((fl(e), this.names.has(e))) this.names.get(e).add(r);
        else {
          var o = new Set();
          (o.add(r), this.names.set(e, o));
        }
      }),
      (n.prototype.insertRules = function (e, r, o) {
        (this.registerName(e, r), this.getTag().insertRules(fl(e), o));
      }),
      (n.prototype.clearNames = function (e) {
        this.names.has(e) && this.names.get(e).clear();
      }),
      (n.prototype.clearRules = function (e) {
        (this.getTag().clearGroup(fl(e)), this.clearNames(e));
      }),
      (n.prototype.clearTag = function () {
        this.tag = void 0;
      }),
      n
    );
  })(),
  W2 = /&/g,
  q2 = /^\s*\/\/.*$/gm;
function I0(n, e) {
  return n.map(function (r) {
    return (
      r.type === "rule" &&
        ((r.value = "".concat(e, " ").concat(r.value)),
        (r.value = r.value.replaceAll(",", ",".concat(e, " "))),
        (r.props = r.props.map(function (o) {
          return "".concat(e, " ").concat(o);
        }))),
      Array.isArray(r.children) &&
        r.type !== "@keyframes" &&
        (r.children = I0(r.children, e)),
      r
    );
  });
}
function G2(n) {
  var e,
    r,
    o,
    l = Nr,
    u = l.options,
    c = u === void 0 ? Nr : u,
    d = l.plugins,
    p = d === void 0 ? ta : d,
    m = function (C, x, b) {
      return b.startsWith(r) && b.endsWith(r) && b.replaceAll(r, "").length > 0
        ? ".".concat(e)
        : C;
    },
    g = p.slice();
  (g.push(function (C) {
    C.type === Kl &&
      C.value.includes("&") &&
      (C.props[0] = C.props[0].replace(W2, r).replace(o, m));
  }),
    c.prefix && g.push(v2),
    g.push(m2));
  var v = function (C, x, b, _) {
    (x === void 0 && (x = ""),
      b === void 0 && (b = ""),
      _ === void 0 && (_ = "&"),
      (e = _),
      (r = x),
      (o = new RegExp("\\".concat(r, "\\b"), "g")));
    var E = C.replace(q2, ""),
      T = h2(b || x ? "".concat(b, " ").concat(x, " { ").concat(E, " }") : E);
    c.namespace && (T = I0(T, c.namespace));
    var D = [];
    return (
      Tl(
        T,
        y2(
          g.concat(
            g2(function (I) {
              return D.push(I);
            }),
          ),
        ),
      ),
      D
    );
  };
  return (
    (v.hash = p.length
      ? p
          .reduce(function (C, x) {
            return (x.name || Ko(15), Sr(C, x.name));
          }, E0)
          .toString()
      : ""),
    v
  );
}
var Q2 = new Fl(),
  Bc = G2(),
  L0 = bn.createContext({
    shouldForwardProp: void 0,
    styleSheet: Q2,
    stylis: Bc,
  });
L0.Consumer;
bn.createContext(void 0);
function Uc() {
  return ve.useContext(L0);
}
var Z2 = (function () {
    function n(e, r) {
      var o = this;
      ((this.inject = function (l, u) {
        u === void 0 && (u = Bc);
        var c = o.name + u.hash;
        l.hasNameForId(o.id, c) ||
          l.insertRules(o.id, c, u(o.rules, c, "@keyframes"));
      }),
        (this.name = e),
        (this.id = "sc-keyframes-".concat(e)),
        (this.rules = r),
        u3(this, function () {
          throw Ko(12, String(o.name));
        }));
    }
    return (
      (n.prototype.getName = function (e) {
        return (e === void 0 && (e = Bc), this.name + e.hash);
      }),
      n
    );
  })(),
  K2 = function (n) {
    return n >= "A" && n <= "Z";
  };
function Fd(n) {
  for (var e = "", r = 0; r < n.length; r++) {
    var o = n[r];
    if (r === 1 && o === "-" && n[0] === "-") return n;
    K2(o) ? (e += "-" + o.toLowerCase()) : (e += o);
  }
  return e.startsWith("ms-") ? "-" + e : e;
}
var F0 = function (n) {
    return n == null || n === !1 || n === "";
  },
  A0 = function (n) {
    var e,
      r,
      o = [];
    for (var l in n) {
      var u = n[l];
      n.hasOwnProperty(l) &&
        !F0(u) &&
        ((Array.isArray(u) && u.isCss) || $r(u)
          ? o.push("".concat(Fd(l), ":"), u, ";")
          : qo(u)
            ? o.push.apply(
                o,
                Wo(Wo(["".concat(l, " {")], A0(u), !1), ["}"], !1),
              )
            : o.push(
                ""
                  .concat(Fd(l), ": ")
                  .concat(
                    ((e = l),
                    (r = u) == null || typeof r == "boolean" || r === ""
                      ? ""
                      : typeof r != "number" ||
                          r === 0 ||
                          e in C2 ||
                          e.startsWith("--")
                        ? String(r).trim()
                        : "".concat(r, "px")),
                    ";",
                  ),
              ));
    }
    return o;
  };
function fi(n, e, r, o) {
  if (F0(n)) return [];
  if (a3(n)) return [".".concat(n.styledComponentId)];
  if ($r(n)) {
    if (!$r((u = n)) || (u.prototype && u.prototype.isReactComponent) || !e)
      return [n];
    var l = n(e);
    return fi(l, e, r, o);
  }
  var u;
  return n instanceof Z2
    ? r
      ? (n.inject(r, o), [n.getName(o)])
      : [n]
    : qo(n)
      ? A0(n)
      : Array.isArray(n)
        ? Array.prototype.concat.apply(
            ta,
            n.map(function (c) {
              return fi(c, e, r, o);
            }),
          )
        : [n.toString()];
}
function N0(n) {
  for (var e = 0; e < n.length; e += 1) {
    var r = n[e];
    if ($r(r) && !a3(r)) return !1;
  }
  return !0;
}
var Y2 = P0(ea),
  X2 = (function () {
    function n(e, r, o) {
      ((this.rules = e),
        (this.staticRulesId = ""),
        (this.isStatic = (o === void 0 || o.isStatic) && N0(e)),
        (this.componentId = r),
        (this.baseHash = Sr(Y2, r)),
        (this.baseStyle = o),
        Fl.registerId(r));
    }
    return (
      (n.prototype.generateAndInjectStyles = function (e, r, o) {
        var l = this.baseStyle
          ? this.baseStyle.generateAndInjectStyles(e, r, o)
          : "";
        if (this.isStatic && !o.hash)
          if (
            this.staticRulesId &&
            r.hasNameForId(this.componentId, this.staticRulesId)
          )
            l = Li(l, this.staticRulesId);
          else {
            var u = $c(fi(this.rules, e, r, o)),
              c = Nc(Sr(this.baseHash, u) >>> 0);
            if (!r.hasNameForId(this.componentId, c)) {
              var d = o(u, ".".concat(c), void 0, this.componentId);
              r.insertRules(this.componentId, c, d);
            }
            ((l = Li(l, c)), (this.staticRulesId = c));
          }
        else {
          for (
            var p = Sr(this.baseHash, o.hash), m = "", g = 0;
            g < this.rules.length;
            g++
          ) {
            var v = this.rules[g];
            if (typeof v == "string") m += v;
            else if (v) {
              var C = $c(fi(v, e, r, o));
              ((p = Sr(p, C + g)), (m += C));
            }
          }
          if (m) {
            var x = Nc(p >>> 0);
            (r.hasNameForId(this.componentId, x) ||
              r.insertRules(
                this.componentId,
                x,
                o(m, ".".concat(x), void 0, this.componentId),
              ),
              (l = Li(l, x)));
          }
        }
        return l;
      }),
      n
    );
  })(),
  c3 = bn.createContext(void 0);
c3.Consumer;
var cc = {};
function J2(n, e, r) {
  var o = a3(n),
    l = n,
    u = !uc(n),
    c = e.attrs,
    d = c === void 0 ? ta : c,
    p = e.componentId,
    m =
      p === void 0
        ? (function (R, N) {
            var F = typeof R != "string" ? "sc" : Od(R);
            cc[F] = (cc[F] || 0) + 1;
            var V = "".concat(F, "-").concat(z0(ea + F + cc[F]));
            return N ? "".concat(N, "-").concat(V) : V;
          })(e.displayName, e.parentComponentId)
        : p,
    g = e.displayName,
    v =
      g === void 0
        ? (function (R) {
            return uc(R) ? "styled.".concat(R) : "Styled(".concat(S2(R), ")");
          })(n)
        : g,
    C =
      e.displayName && e.componentId
        ? "".concat(Od(e.displayName), "-").concat(e.componentId)
        : e.componentId || m,
    x = o && l.attrs ? l.attrs.concat(d).filter(Boolean) : d,
    b = e.shouldForwardProp;
  if (o && l.shouldForwardProp) {
    var _ = l.shouldForwardProp;
    if (e.shouldForwardProp) {
      var E = e.shouldForwardProp;
      b = function (R, N) {
        return _(R, N) && E(R, N);
      };
    } else b = _;
  }
  var T = new X2(r, C, o ? l.componentStyle : void 0);
  function D(R, N) {
    return (function (F, V, ie) {
      var he = F.attrs,
        _e = F.componentStyle,
        Se = F.defaultProps,
        We = F.foldedComponentIds,
        Be = F.styledComponentId,
        pe = F.target,
        qe = bn.useContext(c3),
        ft = Uc(),
        Ee = F.shouldForwardProp || ft.shouldForwardProp,
        W = k0(V, qe, Se) || Nr,
        X = (function (de, ce, xe) {
          for (
            var ye,
              Ce = gt(gt({}, ce), { className: void 0, theme: xe }),
              it = 0;
            it < de.length;
            it += 1
          ) {
            var Pn = $r((ye = de[it])) ? ye(Ce) : ye;
            for (var Xt in Pn)
              Ce[Xt] =
                Xt === "className"
                  ? Li(Ce[Xt], Pn[Xt])
                  : Xt === "style"
                    ? gt(gt({}, Ce[Xt]), Pn[Xt])
                    : Pn[Xt];
          }
          return (
            ce.className && (Ce.className = Li(Ce.className, ce.className)),
            Ce
          );
        })(he, V, W),
        q = X.as || pe,
        P = {};
      for (var L in X)
        X[L] === void 0 ||
          L[0] === "$" ||
          L === "as" ||
          (L === "theme" && X.theme === W) ||
          (L === "forwardedAs"
            ? (P.as = X.forwardedAs)
            : (Ee && !Ee(L, q)) || (P[L] = X[L]));
      var le = (function (de, ce) {
          var xe = Uc(),
            ye = de.generateAndInjectStyles(ce, xe.styleSheet, xe.stylis);
          return ye;
        })(_e, X),
        ae = Li(We, Be);
      return (
        le && (ae += " " + le),
        X.className && (ae += " " + X.className),
        (P[uc(q) && !S0.has(q) ? "class" : "className"] = ae),
        (P.ref = ie),
        ve.createElement(q, P)
      );
    })(I, R, N);
  }
  D.displayName = v;
  var I = bn.forwardRef(D);
  return (
    (I.attrs = x),
    (I.componentStyle = T),
    (I.displayName = v),
    (I.shouldForwardProp = b),
    (I.foldedComponentIds = o
      ? Li(l.foldedComponentIds, l.styledComponentId)
      : ""),
    (I.styledComponentId = C),
    (I.target = o ? l.target : n),
    Object.defineProperty(I, "defaultProps", {
      get: function () {
        return this._foldedDefaultProps;
      },
      set: function (R) {
        this._foldedDefaultProps = o
          ? (function (N) {
              for (var F = [], V = 1; V < arguments.length; V++)
                F[V - 1] = arguments[V];
              for (var ie = 0, he = F; ie < he.length; ie++) jc(N, he[ie], !0);
              return N;
            })({}, l.defaultProps, R)
          : R;
      },
    }),
    u3(I, function () {
      return ".".concat(I.styledComponentId);
    }),
    u &&
      D0(I, n, {
        attrs: !0,
        componentStyle: !0,
        displayName: !0,
        foldedComponentIds: !0,
        shouldForwardProp: !0,
        styledComponentId: !0,
        target: !0,
      }),
    I
  );
}
function Ad(n, e) {
  for (var r = [n[0]], o = 0, l = e.length; o < l; o += 1)
    r.push(e[o], n[o + 1]);
  return r;
}
var Nd = function (n) {
  return Object.assign(n, { isCss: !0 });
};
function $0(n) {
  for (var e = [], r = 1; r < arguments.length; r++) e[r - 1] = arguments[r];
  if ($r(n) || qo(n)) return Nd(fi(Ad(ta, Wo([n], e, !0))));
  var o = n;
  return e.length === 0 && o.length === 1 && typeof o[0] == "string"
    ? fi(o)
    : Nd(fi(Ad(o, e)));
}
function Hc(n, e, r) {
  if ((r === void 0 && (r = Nr), !e)) throw Ko(1, e);
  var o = function (l) {
    for (var u = [], c = 1; c < arguments.length; c++) u[c - 1] = arguments[c];
    return n(e, r, $0.apply(void 0, Wo([l], u, !1)));
  };
  return (
    (o.attrs = function (l) {
      return Hc(
        n,
        e,
        gt(gt({}, r), {
          attrs: Array.prototype.concat(r.attrs, l).filter(Boolean),
        }),
      );
    }),
    (o.withConfig = function (l) {
      return Hc(n, e, gt(gt({}, r), l));
    }),
    o
  );
}
var j0 = function (n) {
    return Hc(J2, n);
  },
  Qr = j0;
S0.forEach(function (n) {
  Qr[n] = j0(n);
});
var e6 = (function () {
  function n(e, r) {
    ((this.rules = e),
      (this.componentId = r),
      (this.isStatic = N0(e)),
      Fl.registerId(this.componentId + 1));
  }
  return (
    (n.prototype.createStyles = function (e, r, o, l) {
      var u = l($c(fi(this.rules, r, o, l)), ""),
        c = this.componentId + e;
      o.insertRules(c, c, u);
    }),
    (n.prototype.removeStyles = function (e, r) {
      r.clearRules(this.componentId + e);
    }),
    (n.prototype.renderStyles = function (e, r, o, l) {
      (e > 2 && Fl.registerId(this.componentId + e),
        this.removeStyles(e, o),
        this.createStyles(e, r, o, l));
    }),
    n
  );
})();
function t6(n) {
  for (var e = [], r = 1; r < arguments.length; r++) e[r - 1] = arguments[r];
  var o = $0.apply(void 0, Wo([n], e, !1)),
    l = "sc-global-".concat(z0(JSON.stringify(o))),
    u = new e6(o, l),
    c = function (p) {
      var m = Uc(),
        g = bn.useContext(c3),
        v = bn.useRef(m.styleSheet.allocateGSInstance(l)).current;
      return (
        m.styleSheet.server && d(v, p, m.styleSheet, g, m.stylis),
        bn.useLayoutEffect(
          function () {
            if (!m.styleSheet.server)
              return (
                d(v, p, m.styleSheet, g, m.stylis),
                function () {
                  return u.removeStyles(v, m.styleSheet);
                }
              );
          },
          [v, p, m.styleSheet, g, m.stylis],
        ),
        null
      );
    };
  function d(p, m, g, v, C) {
    if (u.isStatic) u.renderStyles(p, x2, g, C);
    else {
      var x = gt(gt({}, m), { theme: k0(m, v, c.defaultProps) });
      u.renderStyles(p, x, g, C);
    }
  }
  return bn.memo(c);
}
const n6 = t6`
    * {
        box-sizing: border-box;
        user-select: none;
        -webkit-font-smoothing: antialiased;
        margin:0;
        padding:0;
        border:0;
        font-family: 'Gilroy-Light',sans-serif;    
        &::-webkit-scrollbar {
            display: none;
        }
    }

    .center {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
    }

    .nui {
        width: 100%;
        height: 100vh;
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
        /* background: linear-gradient(90deg, #0B0B14 0%, rgba(11, 11, 20, 0.86) 59.69%, rgba(11, 11, 20, 0.60) 142.01%); */
    }

    body{
        color: #fff;
        width: 100%;
        height: 100%;
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
    }
    
    :root {
        font-size: 100%;
    }

    /* 4K+ displays */
    @media screen and (min-width: 3840px) {
        :root {
            font-size: 250%;
        }
    }

    /* 4K */
    @media screen and (min-width: 3072px) and (max-width: 3839px) {
        :root {
            font-size: 215%;
        }
    }

    /* 2K+ */
    @media screen and (min-width: 2560px) and (max-width: 3071px){
        :root {
            font-size: 165%;
        }
    }

    /* 1920x1080 */
    @media screen and (min-width: 1920px) and (max-width: 2559px) {
        :root {
            font-size: 100%;
        }
    }

    @media screen and (min-width: 1280px) and (max-width: 1919px) {
        :root {
            font-size: 85%;
        }
    }

    @media screen and (min-width: 1024px) and (max-width: 1279px) {
        :root {
            font-size: 65%;
        }
    }

    @media screen and (min-width: 768px) and (max-width: 1023px) {
        :root {
            font-size: 65%;
        }
    }

    @media screen and (min-width: 480px) and (max-width: 767px) {
        :root {
            font-size: 55%;
        }
    }

    @media screen and (max-width: 479px) {
        :root {
            font-size: 45%;
        }
    }

`;
var fc = { exports: {} },
  dc = {};
/**
 * @license React
 * use-sync-external-store-with-selector.production.js
 *
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */ var $d;
function i6() {
  if ($d) return dc;
  $d = 1;
  var n = Zl();
  function e(p, m) {
    return (p === m && (p !== 0 || 1 / p === 1 / m)) || (p !== p && m !== m);
  }
  var r = typeof Object.is == "function" ? Object.is : e,
    o = n.useSyncExternalStore,
    l = n.useRef,
    u = n.useEffect,
    c = n.useMemo,
    d = n.useDebugValue;
  return (
    (dc.useSyncExternalStoreWithSelector = function (p, m, g, v, C) {
      var x = l(null);
      if (x.current === null) {
        var b = { hasValue: !1, value: null };
        x.current = b;
      } else b = x.current;
      x = c(
        function () {
          function E(N) {
            if (!T) {
              if (((T = !0), (D = N), (N = v(N)), C !== void 0 && b.hasValue)) {
                var F = b.value;
                if (C(F, N)) return (I = F);
              }
              return (I = N);
            }
            if (((F = I), r(D, N))) return F;
            var V = v(N);
            return C !== void 0 && C(F, V) ? ((D = N), F) : ((D = N), (I = V));
          }
          var T = !1,
            D,
            I,
            R = g === void 0 ? null : g;
          return [
            function () {
              return E(m());
            },
            R === null
              ? void 0
              : function () {
                  return E(R());
                },
          ];
        },
        [m, g, v, C],
      );
      var _ = o(p, x[0], x[1]);
      return (
        u(
          function () {
            ((b.hasValue = !0), (b.value = _));
          },
          [_],
        ),
        d(_),
        _
      );
    }),
    dc
  );
}
var jd;
function r6() {
  return (jd || ((jd = 1), (fc.exports = i6())), fc.exports);
}
var o6 = r6();
function s6(n) {
  n();
}
function l6() {
  let n = null,
    e = null;
  return {
    clear() {
      ((n = null), (e = null));
    },
    notify() {
      s6(() => {
        let r = n;
        for (; r;) (r.callback(), (r = r.next));
      });
    },
    get() {
      const r = [];
      let o = n;
      for (; o;) (r.push(o), (o = o.next));
      return r;
    },
    subscribe(r) {
      let o = !0;
      const l = (e = { callback: r, next: null, prev: e });
      return (
        l.prev ? (l.prev.next = l) : (n = l),
        function () {
          !o ||
            n === null ||
            ((o = !1),
            l.next ? (l.next.prev = l.prev) : (e = l.prev),
            l.prev ? (l.prev.next = l.next) : (n = l.next));
        }
      );
    },
  };
}
var Bd = { notify() {}, get: () => [] };
function a6(n, e) {
  let r,
    o = Bd,
    l = 0,
    u = !1;
  function c(_) {
    g();
    const E = o.subscribe(_);
    let T = !1;
    return () => {
      T || ((T = !0), E(), v());
    };
  }
  function d() {
    o.notify();
  }
  function p() {
    b.onStateChange && b.onStateChange();
  }
  function m() {
    return u;
  }
  function g() {
    (l++, r || ((r = n.subscribe(p)), (o = l6())));
  }
  function v() {
    (l--, r && l === 0 && (r(), (r = void 0), o.clear(), (o = Bd)));
  }
  function C() {
    u || ((u = !0), g());
  }
  function x() {
    u && ((u = !1), v());
  }
  const b = {
    addNestedSub: c,
    notifyNestedSubs: d,
    handleChangeWrapper: p,
    isSubscribed: m,
    trySubscribe: C,
    tryUnsubscribe: x,
    getListeners: () => o,
  };
  return b;
}
var u6 = () =>
    typeof window < "u" &&
    typeof window.document < "u" &&
    typeof window.document.createElement < "u",
  c6 = u6(),
  f6 = () => typeof navigator < "u" && navigator.product === "ReactNative",
  d6 = f6(),
  h6 = () => (c6 || d6 ? ve.useLayoutEffect : ve.useEffect),
  p6 = h6(),
  hc = Symbol.for("react-redux-context"),
  pc = typeof globalThis < "u" ? globalThis : {};
function m6() {
  if (!ve.createContext) return {};
  const n = pc[hc] ?? (pc[hc] = new Map());
  let e = n.get(ve.createContext);
  return (e || ((e = ve.createContext(null)), n.set(ve.createContext, e)), e);
}
var di = m6();
function y6(n) {
  const { children: e, context: r, serverState: o, store: l } = n,
    u = ve.useMemo(() => {
      const p = a6(l);
      return {
        store: l,
        subscription: p,
        getServerState: o ? () => o : void 0,
      };
    }, [l, o]),
    c = ve.useMemo(() => l.getState(), [l]);
  p6(() => {
    const { subscription: p } = u;
    return (
      (p.onStateChange = p.notifyNestedSubs),
      p.trySubscribe(),
      c !== l.getState() && p.notifyNestedSubs(),
      () => {
        (p.tryUnsubscribe(), (p.onStateChange = void 0));
      }
    );
  }, [u, c]);
  const d = r || di;
  return ve.createElement(d.Provider, { value: u }, e);
}
var g6 = y6;
function f3(n = di) {
  return function () {
    return ve.useContext(n);
  };
}
var B0 = f3();
function U0(n = di) {
  const e = n === di ? B0 : f3(n),
    r = () => {
      const { store: o } = e();
      return o;
    };
  return (Object.assign(r, { withTypes: () => r }), r);
}
var v6 = U0();
function C6(n = di) {
  const e = n === di ? v6 : U0(n),
    r = () => e().dispatch;
  return (Object.assign(r, { withTypes: () => r }), r);
}
var w6 = C6(),
  x6 = (n, e) => n === e;
function _6(n = di) {
  const e = n === di ? B0 : f3(n),
    r = (o, l = {}) => {
      const { equalityFn: u = x6 } =
          typeof l == "function" ? { equalityFn: l } : l,
        c = e(),
        { store: d, subscription: p, getServerState: m } = c;
      ve.useRef(!0);
      const g = ve.useCallback(
          {
            [o.name](C) {
              return o(C);
            },
          }[o.name],
          [o],
        ),
        v = o6.useSyncExternalStoreWithSelector(
          p.addNestedSub,
          d.getState,
          m || d.getState,
          g,
          u,
        );
      return (ve.useDebugValue(v), v);
    };
  return (Object.assign(r, { withTypes: () => r }), r);
}
var b6 = _6();
function st(n) {
  return `Minified Redux error #${n}; visit https://redux.js.org/Errors?code=${n} for the full message or use the non-minified dev environment for full errors. `;
}
var k6 = (typeof Symbol == "function" && Symbol.observable) || "@@observable",
  Ud = k6,
  mc = () => Math.random().toString(36).substring(7).split("").join("."),
  S6 = {
    INIT: `@@redux/INIT${mc()}`,
    REPLACE: `@@redux/REPLACE${mc()}`,
    PROBE_UNKNOWN_ACTION: () => `@@redux/PROBE_UNKNOWN_ACTION${mc()}`,
  },
  Al = S6;
function d3(n) {
  if (typeof n != "object" || n === null) return !1;
  let e = n;
  for (; Object.getPrototypeOf(e) !== null;) e = Object.getPrototypeOf(e);
  return Object.getPrototypeOf(n) === e || Object.getPrototypeOf(n) === null;
}
function H0(n, e, r) {
  if (typeof n != "function") throw new Error(st(2));
  if (
    (typeof e == "function" && typeof r == "function") ||
    (typeof r == "function" && typeof arguments[3] == "function")
  )
    throw new Error(st(0));
  if (
    (typeof e == "function" && typeof r > "u" && ((r = e), (e = void 0)),
    typeof r < "u")
  ) {
    if (typeof r != "function") throw new Error(st(1));
    return r(H0)(n, e);
  }
  let o = n,
    l = e,
    u = new Map(),
    c = u,
    d = 0,
    p = !1;
  function m() {
    c === u &&
      ((c = new Map()),
      u.forEach((E, T) => {
        c.set(T, E);
      }));
  }
  function g() {
    if (p) throw new Error(st(3));
    return l;
  }
  function v(E) {
    if (typeof E != "function") throw new Error(st(4));
    if (p) throw new Error(st(5));
    let T = !0;
    m();
    const D = d++;
    return (
      c.set(D, E),
      function () {
        if (T) {
          if (p) throw new Error(st(6));
          ((T = !1), m(), c.delete(D), (u = null));
        }
      }
    );
  }
  function C(E) {
    if (!d3(E)) throw new Error(st(7));
    if (typeof E.type > "u") throw new Error(st(8));
    if (typeof E.type != "string") throw new Error(st(17));
    if (p) throw new Error(st(9));
    try {
      ((p = !0), (l = o(l, E)));
    } finally {
      p = !1;
    }
    return (
      (u = c).forEach((D) => {
        D();
      }),
      E
    );
  }
  function x(E) {
    if (typeof E != "function") throw new Error(st(10));
    ((o = E), C({ type: Al.REPLACE }));
  }
  function b() {
    const E = v;
    return {
      subscribe(T) {
        if (typeof T != "object" || T === null) throw new Error(st(11));
        function D() {
          const R = T;
          R.next && R.next(g());
        }
        return (D(), { unsubscribe: E(D) });
      },
      [Ud]() {
        return this;
      },
    };
  }
  return (
    C({ type: Al.INIT }),
    { dispatch: C, subscribe: v, getState: g, replaceReducer: x, [Ud]: b }
  );
}
function E6(n) {
  Object.keys(n).forEach((e) => {
    const r = n[e];
    if (typeof r(void 0, { type: Al.INIT }) > "u") throw new Error(st(12));
    if (typeof r(void 0, { type: Al.PROBE_UNKNOWN_ACTION() }) > "u")
      throw new Error(st(13));
  });
}
function P6(n) {
  const e = Object.keys(n),
    r = {};
  for (let u = 0; u < e.length; u++) {
    const c = e[u];
    typeof n[c] == "function" && (r[c] = n[c]);
  }
  const o = Object.keys(r);
  let l;
  try {
    E6(r);
  } catch (u) {
    l = u;
  }
  return function (c = {}, d) {
    if (l) throw l;
    let p = !1;
    const m = {};
    for (let g = 0; g < o.length; g++) {
      const v = o[g],
        C = r[v],
        x = c[v],
        b = C(x, d);
      if (typeof b > "u") throw (d && d.type, new Error(st(14)));
      ((m[v] = b), (p = p || b !== x));
    }
    return ((p = p || o.length !== Object.keys(c).length), p ? m : c);
  };
}
function Nl(...n) {
  return n.length === 0
    ? (e) => e
    : n.length === 1
      ? n[0]
      : n.reduce(
          (e, r) =>
            (...o) =>
              e(r(...o)),
        );
}
function z6(...n) {
  return (e) => (r, o) => {
    const l = e(r, o);
    let u = () => {
      throw new Error(st(15));
    };
    const c = { getState: l.getState, dispatch: (p, ...m) => u(p, ...m) },
      d = n.map((p) => p(c));
    return ((u = Nl(...d)(l.dispatch)), { ...l, dispatch: u });
  };
}
function O6(n) {
  return d3(n) && "type" in n && typeof n.type == "string";
}
var V0 = Symbol.for("immer-nothing"),
  Hd = Symbol.for("immer-draftable"),
  Nt = Symbol.for("immer-state");
function an(n, ...e) {
  throw new Error(
    `[Immer] minified error nr: ${n}. Full error at: https://bit.ly/3cXEKWf`,
  );
}
var jr = Object.getPrototypeOf;
function Hi(n) {
  return !!n && !!n[Nt];
}
function jn(n) {
  var e;
  return n
    ? W0(n) ||
        Array.isArray(n) ||
        !!n[Hd] ||
        !!((e = n.constructor) != null && e[Hd]) ||
        ia(n) ||
        ra(n)
    : !1;
}
var M6 = Object.prototype.constructor.toString();
function W0(n) {
  if (!n || typeof n != "object") return !1;
  const e = jr(n);
  if (e === null) return !0;
  const r = Object.hasOwnProperty.call(e, "constructor") && e.constructor;
  return r === Object
    ? !0
    : typeof r == "function" && Function.toString.call(r) === M6;
}
function $l(n, e) {
  na(n) === 0
    ? Reflect.ownKeys(n).forEach((r) => {
        e(r, n[r], n);
      })
    : n.forEach((r, o) => e(o, r, n));
}
function na(n) {
  const e = n[Nt];
  return e ? e.type_ : Array.isArray(n) ? 1 : ia(n) ? 2 : ra(n) ? 3 : 0;
}
function Vc(n, e) {
  return na(n) === 2 ? n.has(e) : Object.prototype.hasOwnProperty.call(n, e);
}
function q0(n, e, r) {
  const o = na(n);
  o === 2 ? n.set(e, r) : o === 3 ? n.add(r) : (n[e] = r);
}
function R6(n, e) {
  return n === e ? n !== 0 || 1 / n === 1 / e : n !== n && e !== e;
}
function ia(n) {
  return n instanceof Map;
}
function ra(n) {
  return n instanceof Set;
}
function Ti(n) {
  return n.copy_ || n.base_;
}
function Wc(n, e) {
  if (ia(n)) return new Map(n);
  if (ra(n)) return new Set(n);
  if (Array.isArray(n)) return Array.prototype.slice.call(n);
  const r = W0(n);
  if (e === !0 || (e === "class_only" && !r)) {
    const o = Object.getOwnPropertyDescriptors(n);
    delete o[Nt];
    let l = Reflect.ownKeys(o);
    for (let u = 0; u < l.length; u++) {
      const c = l[u],
        d = o[c];
      (d.writable === !1 && ((d.writable = !0), (d.configurable = !0)),
        (d.get || d.set) &&
          (o[c] = {
            configurable: !0,
            writable: !0,
            enumerable: d.enumerable,
            value: n[c],
          }));
    }
    return Object.create(jr(n), o);
  } else {
    const o = jr(n);
    if (o !== null && r) return { ...n };
    const l = Object.create(o);
    return Object.assign(l, n);
  }
}
function h3(n, e = !1) {
  return (
    oa(n) ||
      Hi(n) ||
      !jn(n) ||
      (na(n) > 1 && (n.set = n.add = n.clear = n.delete = D6),
      Object.freeze(n),
      e && Object.entries(n).forEach(([r, o]) => h3(o, !0))),
    n
  );
}
function D6() {
  an(2);
}
function oa(n) {
  return Object.isFrozen(n);
}
var T6 = {};
function Vi(n) {
  const e = T6[n];
  return (e || an(0, n), e);
}
var Go;
function G0() {
  return Go;
}
function I6(n, e) {
  return {
    drafts_: [],
    parent_: n,
    immer_: e,
    canAutoFreeze_: !0,
    unfinalizedDrafts_: 0,
  };
}
function Vd(n, e) {
  e &&
    (Vi("Patches"),
    (n.patches_ = []),
    (n.inversePatches_ = []),
    (n.patchListener_ = e));
}
function qc(n) {
  (Gc(n), n.drafts_.forEach(L6), (n.drafts_ = null));
}
function Gc(n) {
  n === Go && (Go = n.parent_);
}
function Wd(n) {
  return (Go = I6(Go, n));
}
function L6(n) {
  const e = n[Nt];
  e.type_ === 0 || e.type_ === 1 ? e.revoke_() : (e.revoked_ = !0);
}
function qd(n, e) {
  e.unfinalizedDrafts_ = e.drafts_.length;
  const r = e.drafts_[0];
  return (
    n !== void 0 && n !== r
      ? (r[Nt].modified_ && (qc(e), an(4)),
        jn(n) && ((n = jl(e, n)), e.parent_ || Bl(e, n)),
        e.patches_ &&
          Vi("Patches").generateReplacementPatches_(
            r[Nt].base_,
            n,
            e.patches_,
            e.inversePatches_,
          ))
      : (n = jl(e, r, [])),
    qc(e),
    e.patches_ && e.patchListener_(e.patches_, e.inversePatches_),
    n !== V0 ? n : void 0
  );
}
function jl(n, e, r) {
  if (oa(e)) return e;
  const o = e[Nt];
  if (!o) return ($l(e, (l, u) => Gd(n, o, e, l, u, r)), e);
  if (o.scope_ !== n) return e;
  if (!o.modified_) return (Bl(n, o.base_, !0), o.base_);
  if (!o.finalized_) {
    ((o.finalized_ = !0), o.scope_.unfinalizedDrafts_--);
    const l = o.copy_;
    let u = l,
      c = !1;
    (o.type_ === 3 && ((u = new Set(l)), l.clear(), (c = !0)),
      $l(u, (d, p) => Gd(n, o, l, d, p, r, c)),
      Bl(n, l, !1),
      r &&
        n.patches_ &&
        Vi("Patches").generatePatches_(o, r, n.patches_, n.inversePatches_));
  }
  return o.copy_;
}
function Gd(n, e, r, o, l, u, c) {
  if (Hi(l)) {
    const d =
        u && e && e.type_ !== 3 && !Vc(e.assigned_, o) ? u.concat(o) : void 0,
      p = jl(n, l, d);
    if ((q0(r, o, p), Hi(p))) n.canAutoFreeze_ = !1;
    else return;
  } else c && r.add(l);
  if (jn(l) && !oa(l)) {
    if (!n.immer_.autoFreeze_ && n.unfinalizedDrafts_ < 1) return;
    (jl(n, l),
      (!e || !e.scope_.parent_) &&
        typeof o != "symbol" &&
        Object.prototype.propertyIsEnumerable.call(r, o) &&
        Bl(n, l));
  }
}
function Bl(n, e, r = !1) {
  !n.parent_ && n.immer_.autoFreeze_ && n.canAutoFreeze_ && h3(e, r);
}
function F6(n, e) {
  const r = Array.isArray(n),
    o = {
      type_: r ? 1 : 0,
      scope_: e ? e.scope_ : G0(),
      modified_: !1,
      finalized_: !1,
      assigned_: {},
      parent_: e,
      base_: n,
      draft_: null,
      copy_: null,
      revoke_: null,
      isManual_: !1,
    };
  let l = o,
    u = p3;
  r && ((l = [o]), (u = Qo));
  const { revoke: c, proxy: d } = Proxy.revocable(l, u);
  return ((o.draft_ = d), (o.revoke_ = c), d);
}
var p3 = {
    get(n, e) {
      if (e === Nt) return n;
      const r = Ti(n);
      if (!Vc(r, e)) return A6(n, r, e);
      const o = r[e];
      return n.finalized_ || !jn(o)
        ? o
        : o === yc(n.base_, e)
          ? (gc(n), (n.copy_[e] = Zc(o, n)))
          : o;
    },
    has(n, e) {
      return e in Ti(n);
    },
    ownKeys(n) {
      return Reflect.ownKeys(Ti(n));
    },
    set(n, e, r) {
      const o = Q0(Ti(n), e);
      if (o != null && o.set) return (o.set.call(n.draft_, r), !0);
      if (!n.modified_) {
        const l = yc(Ti(n), e),
          u = l == null ? void 0 : l[Nt];
        if (u && u.base_ === r)
          return ((n.copy_[e] = r), (n.assigned_[e] = !1), !0);
        if (R6(r, l) && (r !== void 0 || Vc(n.base_, e))) return !0;
        (gc(n), Qc(n));
      }
      return (
        (n.copy_[e] === r && (r !== void 0 || e in n.copy_)) ||
          (Number.isNaN(r) && Number.isNaN(n.copy_[e])) ||
          ((n.copy_[e] = r), (n.assigned_[e] = !0)),
        !0
      );
    },
    deleteProperty(n, e) {
      return (
        yc(n.base_, e) !== void 0 || e in n.base_
          ? ((n.assigned_[e] = !1), gc(n), Qc(n))
          : delete n.assigned_[e],
        n.copy_ && delete n.copy_[e],
        !0
      );
    },
    getOwnPropertyDescriptor(n, e) {
      const r = Ti(n),
        o = Reflect.getOwnPropertyDescriptor(r, e);
      return (
        o && {
          writable: !0,
          configurable: n.type_ !== 1 || e !== "length",
          enumerable: o.enumerable,
          value: r[e],
        }
      );
    },
    defineProperty() {
      an(11);
    },
    getPrototypeOf(n) {
      return jr(n.base_);
    },
    setPrototypeOf() {
      an(12);
    },
  },
  Qo = {};
$l(p3, (n, e) => {
  Qo[n] = function () {
    return ((arguments[0] = arguments[0][0]), e.apply(this, arguments));
  };
});
Qo.deleteProperty = function (n, e) {
  return Qo.set.call(this, n, e, void 0);
};
Qo.set = function (n, e, r) {
  return p3.set.call(this, n[0], e, r, n[0]);
};
function yc(n, e) {
  const r = n[Nt];
  return (r ? Ti(r) : n)[e];
}
function A6(n, e, r) {
  var l;
  const o = Q0(e, r);
  return o
    ? "value" in o
      ? o.value
      : (l = o.get) == null
        ? void 0
        : l.call(n.draft_)
    : void 0;
}
function Q0(n, e) {
  if (!(e in n)) return;
  let r = jr(n);
  for (; r;) {
    const o = Object.getOwnPropertyDescriptor(r, e);
    if (o) return o;
    r = jr(r);
  }
}
function Qc(n) {
  n.modified_ || ((n.modified_ = !0), n.parent_ && Qc(n.parent_));
}
function gc(n) {
  n.copy_ || (n.copy_ = Wc(n.base_, n.scope_.immer_.useStrictShallowCopy_));
}
var N6 = class {
  constructor(n) {
    ((this.autoFreeze_ = !0),
      (this.useStrictShallowCopy_ = !1),
      (this.produce = (e, r, o) => {
        if (typeof e == "function" && typeof r != "function") {
          const u = r;
          r = e;
          const c = this;
          return function (p = u, ...m) {
            return c.produce(p, (g) => r.call(this, g, ...m));
          };
        }
        (typeof r != "function" && an(6),
          o !== void 0 && typeof o != "function" && an(7));
        let l;
        if (jn(e)) {
          const u = Wd(this),
            c = Zc(e, void 0);
          let d = !0;
          try {
            ((l = r(c)), (d = !1));
          } finally {
            d ? qc(u) : Gc(u);
          }
          return (Vd(u, o), qd(l, u));
        } else if (!e || typeof e != "object") {
          if (
            ((l = r(e)),
            l === void 0 && (l = e),
            l === V0 && (l = void 0),
            this.autoFreeze_ && h3(l, !0),
            o)
          ) {
            const u = [],
              c = [];
            (Vi("Patches").generateReplacementPatches_(e, l, u, c), o(u, c));
          }
          return l;
        } else an(1, e);
      }),
      (this.produceWithPatches = (e, r) => {
        if (typeof e == "function")
          return (c, ...d) => this.produceWithPatches(c, (p) => e(p, ...d));
        let o, l;
        return [
          this.produce(e, r, (c, d) => {
            ((o = c), (l = d));
          }),
          o,
          l,
        ];
      }),
      typeof (n == null ? void 0 : n.autoFreeze) == "boolean" &&
        this.setAutoFreeze(n.autoFreeze),
      typeof (n == null ? void 0 : n.useStrictShallowCopy) == "boolean" &&
        this.setUseStrictShallowCopy(n.useStrictShallowCopy));
  }
  createDraft(n) {
    (jn(n) || an(8), Hi(n) && (n = $6(n)));
    const e = Wd(this),
      r = Zc(n, void 0);
    return ((r[Nt].isManual_ = !0), Gc(e), r);
  }
  finishDraft(n, e) {
    const r = n && n[Nt];
    (!r || !r.isManual_) && an(9);
    const { scope_: o } = r;
    return (Vd(o, e), qd(void 0, o));
  }
  setAutoFreeze(n) {
    this.autoFreeze_ = n;
  }
  setUseStrictShallowCopy(n) {
    this.useStrictShallowCopy_ = n;
  }
  applyPatches(n, e) {
    let r;
    for (r = e.length - 1; r >= 0; r--) {
      const l = e[r];
      if (l.path.length === 0 && l.op === "replace") {
        n = l.value;
        break;
      }
    }
    r > -1 && (e = e.slice(r + 1));
    const o = Vi("Patches").applyPatches_;
    return Hi(n) ? o(n, e) : this.produce(n, (l) => o(l, e));
  }
};
function Zc(n, e) {
  const r = ia(n)
    ? Vi("MapSet").proxyMap_(n, e)
    : ra(n)
      ? Vi("MapSet").proxySet_(n, e)
      : F6(n, e);
  return ((e ? e.scope_ : G0()).drafts_.push(r), r);
}
function $6(n) {
  return (Hi(n) || an(10, n), Z0(n));
}
function Z0(n) {
  if (!jn(n) || oa(n)) return n;
  const e = n[Nt];
  let r;
  if (e) {
    if (!e.modified_) return e.base_;
    ((e.finalized_ = !0), (r = Wc(n, e.scope_.immer_.useStrictShallowCopy_)));
  } else r = Wc(n, !0);
  return (
    $l(r, (o, l) => {
      q0(r, o, Z0(l));
    }),
    e && (e.finalized_ = !1),
    r
  );
}
var $t = new N6(),
  K0 = $t.produce;
$t.produceWithPatches.bind($t);
$t.setAutoFreeze.bind($t);
$t.setUseStrictShallowCopy.bind($t);
$t.applyPatches.bind($t);
$t.createDraft.bind($t);
$t.finishDraft.bind($t);
function Y0(n) {
  return ({ dispatch: r, getState: o }) =>
    (l) =>
    (u) =>
      typeof u == "function" ? u(r, o, n) : l(u);
}
var j6 = Y0(),
  B6 = Y0,
  U6 =
    typeof window < "u" && window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__
      ? window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__
      : function () {
          if (arguments.length !== 0)
            return typeof arguments[0] == "object"
              ? Nl
              : Nl.apply(null, arguments);
        };
function Qd(n, e) {
  function r(...o) {
    if (e) {
      let l = e(...o);
      if (!l) throw new Error(Nn(0));
      return {
        type: n,
        payload: l.payload,
        ...("meta" in l && { meta: l.meta }),
        ...("error" in l && { error: l.error }),
      };
    }
    return { type: n, payload: o[0] };
  }
  return (
    (r.toString = () => `${n}`),
    (r.type = n),
    (r.match = (o) => O6(o) && o.type === n),
    r
  );
}
var X0 = class Uo extends Array {
  constructor(...e) {
    (super(...e), Object.setPrototypeOf(this, Uo.prototype));
  }
  static get [Symbol.species]() {
    return Uo;
  }
  concat(...e) {
    return super.concat.apply(this, e);
  }
  prepend(...e) {
    return e.length === 1 && Array.isArray(e[0])
      ? new Uo(...e[0].concat(this))
      : new Uo(...e.concat(this));
  }
};
function Zd(n) {
  return jn(n) ? K0(n, () => {}) : n;
}
function Kd(n, e, r) {
  return n.has(e) ? n.get(e) : n.set(e, r(e)).get(e);
}
function H6(n) {
  return typeof n == "boolean";
}
var V6 = () =>
    function (e) {
      const {
        thunk: r = !0,
        immutableCheck: o = !0,
        serializableCheck: l = !0,
        actionCreatorCheck: u = !0,
      } = e ?? {};
      let c = new X0();
      return (r && (H6(r) ? c.push(j6) : c.push(B6(r.extraArgument))), c);
    },
  W6 = "RTK_autoBatch",
  Yd = (n) => (e) => {
    setTimeout(e, n);
  },
  q6 =
    (n = { type: "raf" }) =>
    (e) =>
    (...r) => {
      const o = e(...r);
      let l = !0,
        u = !1,
        c = !1;
      const d = new Set(),
        p =
          n.type === "tick"
            ? queueMicrotask
            : n.type === "raf"
              ? typeof window < "u" && window.requestAnimationFrame
                ? window.requestAnimationFrame
                : Yd(10)
              : n.type === "callback"
                ? n.queueNotification
                : Yd(n.timeout),
        m = () => {
          ((c = !1), u && ((u = !1), d.forEach((g) => g())));
        };
      return Object.assign({}, o, {
        subscribe(g) {
          const v = () => l && g(),
            C = o.subscribe(v);
          return (
            d.add(g),
            () => {
              (C(), d.delete(g));
            }
          );
        },
        dispatch(g) {
          var v;
          try {
            return (
              (l = !((v = g == null ? void 0 : g.meta) != null && v[W6])),
              (u = !l),
              u && (c || ((c = !0), p(m))),
              o.dispatch(g)
            );
          } finally {
            l = !0;
          }
        },
      });
    },
  G6 = (n) =>
    function (r) {
      const { autoBatch: o = !0 } = r ?? {};
      let l = new X0(n);
      return (o && l.push(q6(typeof o == "object" ? o : void 0)), l);
    };
function Q6(n) {
  const e = V6(),
    {
      reducer: r = void 0,
      middleware: o,
      devTools: l = !0,
      preloadedState: u = void 0,
      enhancers: c = void 0,
    } = n || {};
  let d;
  if (typeof r == "function") d = r;
  else if (d3(r)) d = P6(r);
  else throw new Error(Nn(1));
  let p;
  typeof o == "function" ? (p = o(e)) : (p = e());
  let m = Nl;
  l && (m = U6({ trace: !1, ...(typeof l == "object" && l) }));
  const g = z6(...p),
    v = G6(g);
  let C = typeof c == "function" ? c(v) : v();
  const x = m(...C);
  return H0(d, u, x);
}
function J0(n) {
  const e = {},
    r = [];
  let o;
  const l = {
    addCase(u, c) {
      const d = typeof u == "string" ? u : u.type;
      if (!d) throw new Error(Nn(28));
      if (d in e) throw new Error(Nn(29));
      return ((e[d] = c), l);
    },
    addMatcher(u, c) {
      return (r.push({ matcher: u, reducer: c }), l);
    },
    addDefaultCase(u) {
      return ((o = u), l);
    },
  };
  return (n(l), [e, r, o]);
}
function Z6(n) {
  return typeof n == "function";
}
function K6(n, e) {
  let [r, o, l] = J0(e),
    u;
  if (Z6(n)) u = () => Zd(n());
  else {
    const d = Zd(n);
    u = () => d;
  }
  function c(d = u(), p) {
    let m = [
      r[p.type],
      ...o.filter(({ matcher: g }) => g(p)).map(({ reducer: g }) => g),
    ];
    return (
      m.filter((g) => !!g).length === 0 && (m = [l]),
      m.reduce((g, v) => {
        if (v)
          if (Hi(g)) {
            const x = v(g, p);
            return x === void 0 ? g : x;
          } else {
            if (jn(g)) return K0(g, (C) => v(C, p));
            {
              const C = v(g, p);
              if (C === void 0) {
                if (g === null) return g;
                throw Error(
                  "A case reducer on a non-draftable value must not return undefined",
                );
              }
              return C;
            }
          }
        return g;
      }, d)
    );
  }
  return ((c.getInitialState = u), c);
}
var Y6 = Symbol.for("rtk-slice-createasyncthunk");
function X6(n, e) {
  return `${n}/${e}`;
}
function J6({ creators: n } = {}) {
  var r;
  const e = (r = n == null ? void 0 : n.asyncThunk) == null ? void 0 : r[Y6];
  return function (l) {
    const { name: u, reducerPath: c = u } = l;
    if (!u) throw new Error(Nn(11));
    typeof process < "u";
    const d =
        (typeof l.reducers == "function" ? l.reducers(np()) : l.reducers) || {},
      p = Object.keys(d),
      m = {
        sliceCaseReducersByName: {},
        sliceCaseReducersByType: {},
        actionCreators: {},
        sliceMatchers: [],
      },
      g = {
        addCase(I, R) {
          const N = typeof I == "string" ? I : I.type;
          if (!N) throw new Error(Nn(12));
          if (N in m.sliceCaseReducersByType) throw new Error(Nn(13));
          return ((m.sliceCaseReducersByType[N] = R), g);
        },
        addMatcher(I, R) {
          return (m.sliceMatchers.push({ matcher: I, reducer: R }), g);
        },
        exposeAction(I, R) {
          return ((m.actionCreators[I] = R), g);
        },
        exposeCaseReducer(I, R) {
          return ((m.sliceCaseReducersByName[I] = R), g);
        },
      };
    p.forEach((I) => {
      const R = d[I],
        N = {
          reducerName: I,
          type: X6(u, I),
          createNotation: typeof l.reducers == "function",
        };
      rp(R) ? sp(N, R, g, e) : ip(N, R, g);
    });
    function v() {
      const [I = {}, R = [], N = void 0] =
          typeof l.extraReducers == "function"
            ? J0(l.extraReducers)
            : [l.extraReducers],
        F = { ...I, ...m.sliceCaseReducersByType };
      return K6(l.initialState, (V) => {
        for (let ie in F) V.addCase(ie, F[ie]);
        for (let ie of m.sliceMatchers) V.addMatcher(ie.matcher, ie.reducer);
        for (let ie of R) V.addMatcher(ie.matcher, ie.reducer);
        N && V.addDefaultCase(N);
      });
    }
    const C = (I) => I,
      x = new Map();
    let b;
    function _(I, R) {
      return (b || (b = v()), b(I, R));
    }
    function E() {
      return (b || (b = v()), b.getInitialState());
    }
    function T(I, R = !1) {
      function N(V) {
        let ie = V[I];
        return (typeof ie > "u" && R && (ie = E()), ie);
      }
      function F(V = C) {
        const ie = Kd(x, R, () => new WeakMap());
        return Kd(ie, V, () => {
          const he = {};
          for (const [_e, Se] of Object.entries(l.selectors ?? {}))
            he[_e] = ep(Se, V, E, R);
          return he;
        });
      }
      return {
        reducerPath: I,
        getSelectors: F,
        get selectors() {
          return F(N);
        },
        selectSlice: N,
      };
    }
    const D = {
      name: u,
      reducer: _,
      actions: m.actionCreators,
      caseReducers: m.sliceCaseReducersByName,
      getInitialState: E,
      ...T(c),
      injectInto(I, { reducerPath: R, ...N } = {}) {
        const F = R ?? c;
        return (
          I.inject({ reducerPath: F, reducer: _ }, N),
          { ...D, ...T(F, !0) }
        );
      },
    };
    return D;
  };
}
function ep(n, e, r, o) {
  function l(u, ...c) {
    let d = e(u);
    return (typeof d > "u" && o && (d = r()), n(d, ...c));
  }
  return ((l.unwrapped = n), l);
}
var tp = J6();
function np() {
  function n(e, r) {
    return { _reducerDefinitionType: "asyncThunk", payloadCreator: e, ...r };
  }
  return (
    (n.withTypes = () => n),
    {
      reducer(e) {
        return Object.assign(
          {
            [e.name](...r) {
              return e(...r);
            },
          }[e.name],
          { _reducerDefinitionType: "reducer" },
        );
      },
      preparedReducer(e, r) {
        return {
          _reducerDefinitionType: "reducerWithPrepare",
          prepare: e,
          reducer: r,
        };
      },
      asyncThunk: n,
    }
  );
}
function ip({ type: n, reducerName: e, createNotation: r }, o, l) {
  let u, c;
  if ("reducer" in o) {
    if (r && !op(o)) throw new Error(Nn(17));
    ((u = o.reducer), (c = o.prepare));
  } else u = o;
  l.addCase(n, u)
    .exposeCaseReducer(e, u)
    .exposeAction(e, c ? Qd(n, c) : Qd(n));
}
function rp(n) {
  return n._reducerDefinitionType === "asyncThunk";
}
function op(n) {
  return n._reducerDefinitionType === "reducerWithPrepare";
}
function sp({ type: n, reducerName: e }, r, o, l) {
  if (!l) throw new Error(Nn(18));
  const {
      payloadCreator: u,
      fulfilled: c,
      pending: d,
      rejected: p,
      settled: m,
      options: g,
    } = r,
    v = l(n, u, g);
  (o.exposeAction(e, v),
    c && o.addCase(v.fulfilled, c),
    d && o.addCase(v.pending, d),
    p && o.addCase(v.rejected, p),
    m && o.addMatcher(v.settled, m),
    o.exposeCaseReducer(e, {
      fulfilled: c || dl,
      pending: d || dl,
      rejected: p || dl,
      settled: m || dl,
    }));
}
function dl() {}
function Nn(n) {
  return `Minified Redux Toolkit error #${n}; visit https://redux-toolkit.js.org/Errors?code=${n} for the full message or use the non-minified dev environment for full errors. `;
}
const lp = { searchMember: "", list: [], selected: "ENSOLARADO", points: 2e3 },
  e1 = tp({
    name: "global",
    initialState: lp,
    reducers: {
      addPoints(n, e) {
        const r = e.payload;
        n.points += r;
      },
      removePoints(n, e) {
        const r = e.payload;
        ((n.points -= r), console.log(n.points));
      },
      setSelected(n, e) {
        n.selected = e.payload;
      },
    },
  }),
  ap = e1.reducer,
  { addPoints: Sw, removePoints: Ew, setSelected: up } = e1.actions,
  cp = (n) => n.global,
  fp = Q6({ reducer: { global: ap } }),
  t1 = () => !window.invokeNative,
  dp = () => {},
  hp = (n, e) => {
    const r = ve.useRef(dp);
    (ve.useEffect(() => {
      r.current = e;
    }, [e]),
      ve.useEffect(() => {
        const o = (l) => {
          const { action: u, data: c } = l.data;
          r.current && u === n && r.current(c);
        };
        return (
          window.addEventListener("message", o),
          () => window.removeEventListener("message", o)
        );
      }, [n]));
  };
async function Ml(n, e, r) {
  const o = {
    method: "post",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(e),
  };
  if (t1() && r) return r;
  const l = window.GetParentResourceName
    ? window.GetParentResourceName()
    : "nui-frame-app";
  return await (await fetch(`https://${l}/${n}`, o)).json();
}
const pp = Qr.div`
  width: 18.5em;
  height: 25.375em;
  border-radius: 1em;
  border: 0.125em solid rgba(255, 255, 255, 0.05);
  background: radial-gradient(81.76% 233.33% at 50.52% -53.33%, rgba(0, 0, 0, 0.00) 0%, rgba(121, 144, 249, 0.2) 100%), var(--color-black-80, rgba(0, 0, 0, 0.80));
  background-blend-mode: hard-light, normal;
  display: flex;
  flex-direction: column;
  transition: all 0.3s ease-in-out;
  right: 1em;
  top: 50%;
  transform: translateY(-50%);
  position: absolute;

  & > div {
    &:nth-child(2) {
      margin-top: 0.3125em;
    }

    &:nth-child(4) {
      margin-top: 0.625em;
    }

    &:nth-child(3) {
      margin-top: 0.725em;
    }
  }

  .buttons {
    display: flex;
    width: 17.5em;
    margin-inline: auto;
    gap: 0.5em;


    .reset {
    width: 100%;
    height: 1.75em;
    display: flex;
    padding: 0.25em 1em;
    justify-content: center;
    align-items: center;
    gap: 0.5em;
    align-self: stretch;
    border-radius: 0.25em;
    border: 0.0625em solid rgba(255, 255, 255, 0.10);

    span {
      color: var(--color-white-80, rgba(255, 255, 255, 0.80));
      text-align: center;

      /* text-sm/normal */
      font-family: var(--font-family-sans, Inter);
      font-size: var(--font-size-sm, 0.725em);
      font-style: normal;
      font-weight: var(--font-weight-normal, 400);
      line-height: var(--font-line-height-5, 1.25em); /* 142.857% */
      letter-spacing: var(--font-letter-spacing-normal, 0em);
    }

    &:hover {
      border-radius: var(--radius-DEFAULT, 0.25em);
      border: 0.0625em solid var(--color-white-90, rgba(255, 255, 255, 0.90));
      background: linear-gradient(270deg, #FAE8FF 0.08%, #FDF4FF 99.9%);

      span {
        color: var(--color-black-80, rgb(0, 0, 0));
        text-align: center;
        font-family: var(--font-family-sans, Inter);
        font-style: normal;
        font-weight: var(--font-weight-normal, 400);
        line-height: var(--font-line-height-5, 1.25em); /* 142.857% */
        letter-spacing: var(--font-letter-spacing-normal, 0em);
      }

      svg path {
        stroke: var(--color-black-80, rgb(0, 0, 0));
        opacity: 1;
      }

      svg rect {
        fill: var(--color-black-80, rgb(0, 0, 0));
        opacity: 1;
      }
    }
  }
  }

  
`,
  mp = Qr.div`
    width: 100%;
    border-radius: 1em 1em 0em 0em;
    border-bottom: 0.0625em solid rgba(217, 70, 239, 0.00);
    background: linear-gradient(90deg, rgba(217, 70, 239, 0.00) 0%, #4673efff 50%, rgba(217, 70, 239, 0.00) 100%);
    display: flex;
    padding: 0.25em 0em;
    justify-content: center;
    align-items: center;
    gap: 0.25em;
    align-self: stretch;

    .title {
      color: #FFF;
      text-align: center;
      leading-trim: both;
      text-edge: cap;
      font-family: 'Arame', sans-serif;
      font-size: 0.75em;
      font-style: normal;
      font-weight: 400;
      line-height: 1.25em; /* 166.667% */
      letter-spacing: 0em;
  }

  .warning {
    font-family: gilroy-regular, sans-serif;
    font-style: normal;
    font-weight: 500;
    font-size: 0.9375em;
    color: rgb(255, 255, 255);
    width: 14em;

  }

  .bContainer {
    width: 19.125em;
    height: 5.125em;
    background: linear-gradient(90deg,rgba(255,255,255,0.15) 0%,rgba(255,255,255,0) 100%);
    border: 0.0625em solid rgba(255,255,255,0.06);
    border-radius: 0.1875em;
    display: -webkit-box;
    display: -webkit-flex;
    display: -ms-flexbox;
    display: flex;
    align-items: center;
    justify-content: space-around;


    .square {
        width: 3.5em;
        height: 3.5em;
        background-image: url("https://cache.nowayrp.uk/Scripts%2FFacs%2Ffluxorj_gif.gif");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
        border-radius: 0.4375em;

    }

    button {
        height: 3.125em;
        font-family: 'Gilroy';
        font-style: normal;
        font-weight: 900;
        font-size: 1.5625em;
        line-height: 2.75em;

        text-transform: uppercase;

        color: rgba(255, 255, 255, 0.14);

        /* border: 1px solid #FFFFFF; */
        text-shadow: 0em 0em 2.125em rgba(255, 255, 255, 0.55);
        -webkit-text-stroke: 0.0625em rgba(255, 255, 255, 0.55);
        padding: 0 .5em;
        background: #00000039;
        border-radius: 0.4375em;
    }
  }
`,
  yp = () =>
    J.jsxs(mp, {
      children: [
        J.jsx(gp, {}),
        J.jsx("div", { className: "title", children: "Controle de Clima" }),
      ],
    }),
  gp = () =>
    J.jsxs("svg", {
      xmlns: "http://www.w3.org/2000/svg",
      width: "24",
      height: "28",
      viewBox: "0 0 24 28",
      fill: "none",
      children: [
        J.jsx("path", {
          opacity: "0.5",
          d: "M16.2857 18C19.4416 18 22 15.4717 22 12.3529C22 9.88113 20.393 7.78024 18.1551 7.01498C17.8371 4.19371 15.4159 2 12.4762 2C9.32028 2 6.7619 4.52827 6.7619 7.64706C6.7619 8.33687 6.88706 8.9978 7.11616 9.60887C6.8475 9.55673 6.56983 9.52941 6.28571 9.52941C3.91878 9.52941 2 11.4256 2 13.7647C2 16.1038 3.91878 18 6.28571 18H16.2857Z",
          fill: "#FAF5FF",
        }),
        J.jsx("g", {
          filter: "url(#filter0_d_1082_56)",
          children: J.jsx("path", {
            d: "M9.62607 17.4651L10.7744 15.9104C11.5166 14.9054 11.8878 14.4029 12.234 14.5091C12.5803 14.6153 12.5803 15.2316 12.5803 16.4642V16.5804C12.5803 17.025 12.5803 17.2472 12.7222 17.3867L12.7297 17.3939C12.8748 17.5304 13.106 17.5304 13.5683 17.5304C14.4004 17.5304 14.8165 17.5304 14.9571 17.7829C14.9594 17.7871 14.9617 17.7913 14.9639 17.7955C15.0966 18.052 14.8557 18.3781 14.3739 19.0304L13.2256 20.5851C12.4833 21.5901 12.1122 22.0926 11.7659 21.9864C11.4197 21.8802 11.4197 21.2639 11.4197 20.0313L11.4197 19.9151C11.4197 19.4705 11.4197 19.2483 11.2778 19.1088L11.2703 19.1016C11.1252 18.9651 10.894 18.9651 10.4317 18.9651C9.59958 18.9651 9.18354 18.9651 9.04294 18.7126C9.04061 18.7084 9.03835 18.7042 9.03615 18.6999C8.90342 18.4435 9.1443 18.1174 9.62607 17.4651Z",
            fill: "#FAF5FF",
          }),
        }),
        J.jsx("defs", {
          children: J.jsxs("filter", {
            id: "filter0_d_1082_56",
            x: "3",
            y: "8.49512",
            width: "18",
            height: "19.5052",
            filterUnits: "userSpaceOnUse",
            "color-interpolation-filters": "sRGB",
            children: [
              J.jsx("feFlood", {
                "flood-opacity": "0",
                result: "BackgroundImageFix",
              }),
              J.jsx("feColorMatrix", {
                in: "SourceAlpha",
                type: "matrix",
                values: "0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0",
                result: "hardAlpha",
              }),
              J.jsx("feOffset", {}),
              J.jsx("feGaussianBlur", { stdDeviation: "3" }),
              J.jsx("feComposite", { in2: "hardAlpha", operator: "out" }),
              J.jsx("feColorMatrix", {
                type: "matrix",
                values:
                  "0 0 0 0 0.909804 0 0 0 0 0.47451 0 0 0 0 0.976471 0 0 0 1 0",
              }),
              J.jsx("feBlend", {
                mode: "normal",
                in2: "BackgroundImageFix",
                result: "effect1_dropShadow_1082_56",
              }),
              J.jsx("feBlend", {
                mode: "normal",
                in: "SourceGraphic",
                in2: "effect1_dropShadow_1082_56",
                result: "shape",
              }),
            ],
          }),
        }),
      ],
    }),
  Xd = {
    ENSOLARADO: {
      background: "linear-gradient(93deg, #FDBA74 0.25%, #FDE047 102.13%)",
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
    },
    NEBLINA: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #FDBA74 0.25%, #FFF 102.13%)",
    },
    NUBLADO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #E0F2FE 0.25%, #FDE047 102.13%)",
    },
    TEMPESTADE: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #7DD3FC 0.25%, #FDE047 102.13%)",
    },
    CHUVOSO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #E0F2FE 0.25%, #7DD3FC 102.13%)",
    },
    NEVE: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #BAE6FD 0.25%, #FFF 102.13%)",
    },
    LIMPO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #FDBA74 0.25%, #FDE047 102.13%)",
    },
    NEUTRO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #E0F2FE 0.25%, #FDE047 102.13%)",
    },
    POLUIDO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #FDBA74 0.25%, #FFF 102.13%)",
    },
    ENCOBERTO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #E0F2FE 0.25%, #FDE047 102.13%)",
    },
    LIMPANDO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #E0F2FE 0.25%, #7DD3FC 102.13%)",
    },
    NEVANDO: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #BAE6FD 0.25%, #FFF 102.13%)",
    },
    NEVASCA: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #BAE6FD 0.25%, #FFF 102.13%)",
    },
    NEVE_LEVE: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #BAE6FD 0.25%, #FFF 102.13%)",
    },
    HALLOWEEN: {
      border: "0.0625em solid rgba(255, 255, 255, 0.20)",
      background: "linear-gradient(93deg, #7DD3FC 0.25%, #FDE047 102.13%)",
    },
  },
  Jd = {
    ENSOLARADO: {
      border: "0.5px solid var(--color-yellow-200, #FEF08A)",
      background:
        "linear-gradient(0deg, rgba(254, 249, 195, 0.10) 0%, rgba(254, 249, 195, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NEBLINA: {
      border: "0.5px solid var(--color-sky-50, #F0F9FF)",
      background:
        "linear-gradient(0deg, rgba(195, 227, 254, 0.10) 0%, rgba(195, 227, 254, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NUBLADO: {
      border: "0.5px solid var(--color-yellow-50, #FEFCE8)",
      background:
        "linear-gradient(0deg, rgba(147, 197, 253, 0.05) 0%, rgba(147, 197, 253, 0.05) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    TEMPESTADE: {
      border: "0.5px solid var(--color-yellow-200, #FEF08A)",
      background:
        "linear-gradient(0deg, rgba(254, 249, 195, 0.10) 0%, rgba(254, 249, 195, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    CHUVOSO: {
      border: "0.5px solid var(--color-sky-300, #7DD3FC)",
      background:
        "linear-gradient(0deg, rgba(125, 211, 252, 0.10) 0%, rgba(125, 211, 252, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NEVE: {
      border: "0.5px solid var(--color-sky-50, #F0F9FF)",
      background:
        "linear-gradient(0deg, rgba(195, 231, 254, 0.10) 0%, rgba(195, 231, 254, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    LIMPO: {
      border: "0.5px solid var(--color-yellow-200, #FEF08A)",
      background:
        "linear-gradient(0deg, rgba(254, 249, 195, 0.10) 0%, rgba(254, 249, 195, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NEUTRO: {
      border: "0.5px solid var(--color-yellow-50, #FEFCE8)",
      background:
        "linear-gradient(0deg, rgba(147, 197, 253, 0.05) 0%, rgba(147, 197, 253, 0.05) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    POLUIDO: {
      border: "0.5px solid var(--color-sky-50, #F0F9FF)",
      background:
        "linear-gradient(0deg, rgba(195, 227, 254, 0.10) 0%, rgba(195, 227, 254, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    ENCOBERTO: {
      border: "0.5px solid var(--color-yellow-50, #FEFCE8)",
      background:
        "linear-gradient(0deg, rgba(147, 197, 253, 0.05) 0%, rgba(147, 197, 253, 0.05) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    LIMPANDO: {
      border: "0.5px solid var(--color-sky-300, #7DD3FC)",
      background:
        "linear-gradient(0deg, rgba(125, 211, 252, 0.10) 0%, rgba(125, 211, 252, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NEVANDO: {
      border: "0.5px solid var(--color-sky-50, #F0F9FF)",
      background:
        "linear-gradient(0deg, rgba(195, 231, 254, 0.10) 0%, rgba(195, 231, 254, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NEVASCA: {
      border: "0.5px solid var(--color-sky-50, #F0F9FF)",
      background:
        "linear-gradient(0deg, rgba(195, 231, 254, 0.10) 0%, rgba(195, 231, 254, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    NEVE_LEVE: {
      border: "0.5px solid var(--color-sky-50, #F0F9FF)",
      background:
        "linear-gradient(0deg, rgba(195, 231, 254, 0.10) 0%, rgba(195, 231, 254, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
    HALLOWEEN: {
      border: "0.5px solid var(--color-yellow-200, #FEF08A)",
      background:
        "linear-gradient(0deg, rgba(254, 249, 195, 0.10) 0%, rgba(254, 249, 195, 0.10) 100%), var(--color-white-5, rgba(255, 255, 255, 0.05))",
    },
  },
  vp = Qr.div`
  display: flex;
  padding: 0em 0.5em;
  align-items: flex-start;
  gap: 0.25em;
  align-self: stretch;
  
  .weather {
    display: flex;
    width: 17.5em;
    padding: 0.25em 0.375em;
    align-items: center;
    border-radius: 0.25em;
    gap: 0.4375em;
    background: ${(n) => Jd[n.name || "ENSOLARADO"].background};
    border: ${(n) => Jd[n.name || "ENSOLARADO"].border};
    min-height: 3em;
    position: relative;
    overflow: hidden;

    

    &-name {
      display: flex;
      padding: 0.25em 0.375em;
      flex-direction: column;
      justify-content: center;
      align-items: flex-start;
      border-radius: 0.25em;
      background: ${(n) => Xd[n.name || "ENSOLARADO"].background};
      border: ${(n) => Xd[n.name || "ENSOLARADO"].border};


      span {
        color: rgba(0, 0, 0, 0.60);
        text-align: center;
        leading-trim: both;
        text-edge: cap;
        font-family: Inter;
        font-size: 0.625em;
        font-style: normal;
        font-weight: 800;
        line-height: 1em;
        letter-spacing: 0em;
      }
    }

    .current {
      color: rgba(255, 255, 255, 0.80);
      text-align: center;
      font-family: Inter;
      font-size: 0.625em;
      font-style: normal;
      font-weight: 400;
      line-height: 1em;
      letter-spacing: 0em;
    }

    #sep {
      width: 0.0625em;
      height: 0.4375em;
      background: rgba(255, 255, 255, 0.20);
    }

    .hour {
      color: rgba(255, 255, 255, 0.80);
      text-align: center;
      font-family: Inter;
      font-size: 0.625em;
      font-style: normal;
      font-weight: 600;
      line-height: 1em;
      letter-spacing: 0em;
      margin-left: auto;

      span {
        color: rgba(255, 255, 255, 0.40);
        font-family: Inter;
        font-size: 0.625em;
        font-style: normal;
        font-weight: 400;
        line-height: 1em;
        letter-spacing: 0em;
        margin-left: 0.25em;
      }
    }
  }
`,
  n1 = "" + new URL("CHUVOSO-Cl26H-XB.png", import.meta.url).href,
  i1 = "" + new URL("NUBLADO-DkMiTbH5.png", import.meta.url).href,
  r1 = "" + new URL("ENSOLARADO-D9hqQOqI.png", import.meta.url).href,
  o1 = "" + new URL("TEMPESTADE-CjzC7Zuq.png", import.meta.url).href,
  s1 = "" + new URL("NEVE-CDq6zNbc.png", import.meta.url).href,
  l1 = "" + new URL("NEBLINA-DLG1IJmX.png", import.meta.url).href,
  Fi = "generated",
  Cp = "pointerdown",
  wp = "pointerup",
  Kc = "pointerleave",
  xp = "pointerout",
  Wi = "pointermove",
  _p = "touchstart",
  eh = "touchend",
  bp = "touchmove",
  kp = "touchcancel",
  Sp = "resize",
  Ep = "visibilitychange",
  Kt = "tsParticles - Error",
  at = 100,
  qi = 0.5,
  Fe = 1e3;
var lt;
(function (n) {
  ((n.bottom = "bottom"),
    (n.bottomLeft = "bottom-left"),
    (n.bottomRight = "bottom-right"),
    (n.left = "left"),
    (n.none = "none"),
    (n.right = "right"),
    (n.top = "top"),
    (n.topLeft = "top-left"),
    (n.topRight = "top-right"),
    (n.outside = "outside"),
    (n.inside = "inside"));
})(lt || (lt = {}));
function a1(n) {
  return typeof n == "boolean";
}
function hi(n) {
  return typeof n == "string";
}
function jt(n) {
  return typeof n == "number";
}
function Er(n) {
  return typeof n == "object" && n !== null;
}
function vt(n) {
  return Array.isArray(n);
}
function $(n) {
  return n == null;
}
const xn = { x: 0, y: 0, z: 0 },
  th = 2,
  Pp = 1;
class At {
  constructor(e, r, o) {
    if (
      ((this._updateFromAngle = (l, u) => {
        ((this.x = Math.cos(l) * u), (this.y = Math.sin(l) * u));
      }),
      !jt(e) && e)
    ) {
      ((this.x = e.x), (this.y = e.y));
      const l = e;
      this.z = l.z ? l.z : xn.z;
    } else if (e !== void 0 && r !== void 0)
      ((this.x = e), (this.y = r), (this.z = o ?? xn.z));
    else throw new Error(`${Kt} Vector3d not initialized correctly`);
  }
  static get origin() {
    return At.create(xn.x, xn.y, xn.z);
  }
  get angle() {
    return Math.atan2(this.y, this.x);
  }
  set angle(e) {
    this._updateFromAngle(e, this.length);
  }
  get length() {
    return Math.sqrt(this.getLengthSq());
  }
  set length(e) {
    this._updateFromAngle(this.angle, e);
  }
  static clone(e) {
    return At.create(e.x, e.y, e.z);
  }
  static create(e, r, o) {
    return new At(e, r, o);
  }
  add(e) {
    return At.create(this.x + e.x, this.y + e.y, this.z + e.z);
  }
  addTo(e) {
    ((this.x += e.x), (this.y += e.y), (this.z += e.z));
  }
  copy() {
    return At.clone(this);
  }
  distanceTo(e) {
    return this.sub(e).length;
  }
  distanceToSq(e) {
    return this.sub(e).getLengthSq();
  }
  div(e) {
    return At.create(this.x / e, this.y / e, this.z / e);
  }
  divTo(e) {
    ((this.x /= e), (this.y /= e), (this.z /= e));
  }
  getLengthSq() {
    return this.x ** th + this.y ** th;
  }
  mult(e) {
    return At.create(this.x * e, this.y * e, this.z * e);
  }
  multTo(e) {
    ((this.x *= e), (this.y *= e), (this.z *= e));
  }
  normalize() {
    const e = this.length;
    e != 0 && this.multTo(Pp / e);
  }
  rotate(e) {
    return At.create(
      this.x * Math.cos(e) - this.y * Math.sin(e),
      this.x * Math.sin(e) + this.y * Math.cos(e),
      xn.z,
    );
  }
  setTo(e) {
    ((this.x = e.x), (this.y = e.y));
    const r = e;
    this.z = r.z ? r.z : xn.z;
  }
  sub(e) {
    return At.create(this.x - e.x, this.y - e.y, this.z - e.z);
  }
  subFrom(e) {
    ((this.x -= e.x), (this.y -= e.y), (this.z -= e.z));
  }
}
class ze extends At {
  constructor(e, r) {
    super(e, r, xn.z);
  }
  static get origin() {
    return ze.create(xn.x, xn.y);
  }
  static clone(e) {
    return ze.create(e.x, e.y);
  }
  static create(e, r) {
    return new ze(e, r);
  }
}
let zp = Math.random;
const u1 = {
    nextFrame: (n) => requestAnimationFrame(n),
    cancel: (n) => cancelAnimationFrame(n),
  },
  Op = 2,
  Mp = Math.PI * Op;
function se() {
  return Yt(zp(), 0, 1 - Number.EPSILON);
}
function Rp(n) {
  return u1.nextFrame(n);
}
function Dp(n) {
  u1.cancel(n);
}
function Yt(n, e, r) {
  return Math.min(Math.max(n, e), r);
}
function vc(n, e, r, o) {
  return Math.floor((n * r + e * o) / (r + o));
}
function ut(n) {
  const e = kn(n),
    r = 0;
  let o = sa(n);
  return (e === o && (o = r), se() * (e - o) + o);
}
function H(n) {
  return jt(n) ? n : ut(n);
}
function sa(n) {
  return jt(n) ? n : n.min;
}
function kn(n) {
  return jt(n) ? n : n.max;
}
function ee(n, e) {
  if (n === e || (e === void 0 && jt(n))) return n;
  const r = sa(n),
    o = kn(n);
  return e !== void 0 ? { min: Math.min(r, e), max: Math.max(o, e) } : ee(r, o);
}
function Ct(n, e) {
  const r = n.x - e.x,
    o = n.y - e.y,
    l = 2;
  return { dx: r, dy: o, distance: Math.sqrt(r ** l + o ** l) };
}
function kt(n, e) {
  return Ct(n, e).distance;
}
function $n(n) {
  return (n * Math.PI) / 180;
}
function Tp(n, e, r) {
  if (jt(n)) return $n(n);
  const o = 0,
    l = 0.5,
    u = 0.25,
    c = l + u;
  switch (n) {
    case lt.top:
      return -Math.PI * l;
    case lt.topRight:
      return -Math.PI * u;
    case lt.right:
      return o;
    case lt.bottomRight:
      return Math.PI * u;
    case lt.bottom:
      return Math.PI * l;
    case lt.bottomLeft:
      return Math.PI * c;
    case lt.left:
      return Math.PI;
    case lt.topLeft:
      return -Math.PI * c;
    case lt.inside:
      return Math.atan2(r.y - e.y, r.x - e.x);
    case lt.outside:
      return Math.atan2(e.y - r.y, e.x - r.x);
    default:
      return se() * Mp;
  }
}
function Ip(n) {
  const e = ze.origin;
  return ((e.length = 1), (e.angle = n), e);
}
function nh(n, e, r, o) {
  return ze.create((n.x * (r - o)) / (r + o) + (e.x * 2 * o) / (r + o), n.y);
}
function c1(n) {
  var e, r;
  return {
    x:
      ((((e = n.position) == null ? void 0 : e.x) ?? se() * at) *
        n.size.width) /
      at,
    y:
      ((((r = n.position) == null ? void 0 : r.y) ?? se() * at) *
        n.size.height) /
      at,
  };
}
function f1(n) {
  var r, o;
  const e = {
    x:
      ((r = n.position) == null ? void 0 : r.x) !== void 0
        ? H(n.position.x)
        : void 0,
    y:
      ((o = n.position) == null ? void 0 : o.y) !== void 0
        ? H(n.position.y)
        : void 0,
  };
  return c1({ size: n.size, position: e });
}
function Lp(n) {
  var e, r;
  return {
    x: ((e = n.position) == null ? void 0 : e.x) ?? se() * n.size.width,
    y: ((r = n.position) == null ? void 0 : r.y) ?? se() * n.size.height,
  };
}
function d1(n) {
  return n ? (n.endsWith("%") ? parseFloat(n) / at : parseFloat(n)) : 1;
}
var Ai;
(function (n) {
  ((n.auto = "auto"),
    (n.increase = "increase"),
    (n.decrease = "decrease"),
    (n.random = "random"));
})(Ai || (Ai = {}));
var $e;
(function (n) {
  ((n.increasing = "increasing"), (n.decreasing = "decreasing"));
})($e || ($e = {}));
var pi;
(function (n) {
  ((n.none = "none"), (n.max = "max"), (n.min = "min"));
})(pi || (pi = {}));
var me;
(function (n) {
  ((n.bottom = "bottom"),
    (n.left = "left"),
    (n.right = "right"),
    (n.top = "top"));
})(me || (me = {}));
var En;
(function (n) {
  ((n.precise = "precise"), (n.percent = "percent"));
})(En || (En = {}));
var Mr;
(function (n) {
  ((n.max = "max"), (n.min = "min"), (n.random = "random"));
})(Mr || (Mr = {}));
const Fp = {
  debug: console.debug,
  error: console.error,
  info: console.info,
  log: console.log,
  verbose: console.log,
  warning: console.warn,
};
function Gi() {
  return Fp;
}
function ih(n) {
  const e = { bounced: !1 },
    {
      pSide: r,
      pOtherSide: o,
      rectSide: l,
      rectOtherSide: u,
      velocity: c,
      factor: d,
    } = n,
    p = 0.5,
    m = 0;
  return (
    o.min < u.min ||
      o.min > u.max ||
      o.max < u.min ||
      o.max > u.max ||
      (((r.max >= l.min && r.max <= (l.max + l.min) * p && c > m) ||
        (r.min <= l.max && r.min > (l.max + l.min) * p && c < m)) &&
        ((e.velocity = c * -d), (e.bounced = !0))),
    e
  );
}
function Ap(n, e) {
  const r = Ke(e, (o) => n.matches(o));
  return vt(r) ? r.some((o) => o) : r;
}
function Qi() {
  return (
    typeof window > "u" ||
    !window ||
    typeof window.document > "u" ||
    !window.document
  );
}
function Np() {
  return !Qi() && typeof matchMedia < "u";
}
function h1(n) {
  if (Np()) return matchMedia(n);
}
function $p(n) {
  if (!(Qi() || typeof IntersectionObserver > "u"))
    return new IntersectionObserver(n);
}
function jp(n) {
  if (!(Qi() || typeof MutationObserver > "u")) return new MutationObserver(n);
}
function Oe(n, e) {
  return n === e || (vt(e) && e.indexOf(n) > -1);
}
async function Yc(n, e) {
  try {
    await document.fonts.load(`${e ?? "400"} 36px '${n ?? "Verdana"}'`);
  } catch {}
}
function p1(n) {
  return Math.floor(se() * n.length);
}
function Yo(n, e, r = !0) {
  return n[e !== void 0 && r ? e % n.length : p1(n)];
}
function Xo(n, e, r, o, l) {
  return Bp(Jo(n, o ?? 0), e, r, l);
}
function Bp(n, e, r, o) {
  let l = !0;
  return (
    (!o || o === me.bottom) && (l = n.top < e.height + r.x),
    l && (!o || o === me.left) && (l = n.right > r.x),
    l && (!o || o === me.right) && (l = n.left < e.width + r.y),
    l && (!o || o === me.top) && (l = n.bottom > r.y),
    l
  );
}
function Jo(n, e) {
  return { bottom: n.y + e, left: n.x - e, right: n.x + e, top: n.y - e };
}
function je(n, ...e) {
  for (const r of e) {
    if (r == null) continue;
    if (!Er(r)) {
      n = r;
      continue;
    }
    const o = Array.isArray(r);
    o && (Er(n) || !n || !Array.isArray(n))
      ? (n = [])
      : !o && (Er(n) || !n || Array.isArray(n)) && (n = {});
    for (const l in r) {
      if (l === "__proto__") continue;
      const u = r,
        c = u[l],
        d = n;
      d[l] =
        Er(c) && Array.isArray(c) ? c.map((p) => je(d[l], p)) : je(d[l], c);
    }
  }
  return n;
}
function m3(n, e) {
  return !!g1(e, (r) => r.enable && Oe(n, r.mode));
}
function y3(n, e, r) {
  Ke(e, (o) => {
    const l = o.mode;
    o.enable && Oe(n, l) && Up(o, r);
  });
}
function Up(n, e) {
  const r = n.selectors;
  Ke(r, (o) => {
    e(o, n);
  });
}
function m1(n, e) {
  if (!(!e || !n)) return g1(n, (r) => Ap(e, r.selectors));
}
function Xc(n) {
  return {
    position: n.getPosition(),
    radius: n.getRadius(),
    mass: n.getMass(),
    velocity: n.velocity,
    factor: ze.create(
      H(n.options.bounce.horizontal.value),
      H(n.options.bounce.vertical.value),
    ),
  };
}
function y1(n, e) {
  const { x: r, y: o } = n.velocity.sub(e.velocity),
    [l, u] = [n.position, e.position],
    { dx: c, dy: d } = Ct(u, l);
  if (r * c + o * d < 0) return;
  const m = -Math.atan2(d, c),
    g = n.mass,
    v = e.mass,
    C = n.velocity.rotate(m),
    x = e.velocity.rotate(m),
    b = nh(C, x, g, v),
    _ = nh(x, C, g, v),
    E = b.rotate(-m),
    T = _.rotate(-m);
  ((n.velocity.x = E.x * n.factor.x),
    (n.velocity.y = E.y * n.factor.y),
    (e.velocity.x = T.x * e.factor.x),
    (e.velocity.y = T.y * e.factor.y));
}
function Hp(n, e) {
  const r = n.getPosition(),
    o = n.getRadius(),
    l = Jo(r, o),
    u = n.options.bounce,
    c = ih({
      pSide: { min: l.left, max: l.right },
      pOtherSide: { min: l.top, max: l.bottom },
      rectSide: { min: e.left, max: e.right },
      rectOtherSide: { min: e.top, max: e.bottom },
      velocity: n.velocity.x,
      factor: H(u.horizontal.value),
    });
  c.bounced &&
    (c.velocity !== void 0 && (n.velocity.x = c.velocity),
    c.position !== void 0 && (n.position.x = c.position));
  const d = ih({
    pSide: { min: l.top, max: l.bottom },
    pOtherSide: { min: l.left, max: l.right },
    rectSide: { min: e.top, max: e.bottom },
    rectOtherSide: { min: e.left, max: e.right },
    velocity: n.velocity.y,
    factor: H(u.vertical.value),
  });
  d.bounced &&
    (d.velocity !== void 0 && (n.velocity.y = d.velocity),
    d.position !== void 0 && (n.position.y = d.position));
}
function Ke(n, e) {
  return vt(n) ? n.map((o, l) => e(o, l)) : e(n, 0);
}
function ct(n, e, r) {
  return vt(n) ? Yo(n, e, r) : n;
}
function g1(n, e) {
  return vt(n) ? n.find((o, l) => e(o, l)) : e(n, 0) ? n : void 0;
}
function v1(n, e) {
  const r = n.value,
    o = n.animation,
    l = {
      delayTime: H(o.delay) * Fe,
      enable: o.enable,
      value: H(n.value) * e,
      max: kn(r) * e,
      min: sa(r) * e,
      loops: 0,
      maxLoops: H(o.count),
      time: 0,
    },
    u = 1;
  if (o.enable) {
    switch (((l.decay = u - H(o.decay)), o.mode)) {
      case Ai.increase:
        l.status = $e.increasing;
        break;
      case Ai.decrease:
        l.status = $e.decreasing;
        break;
      case Ai.random:
        l.status = se() >= qi ? $e.increasing : $e.decreasing;
        break;
    }
    const c = o.mode === Ai.auto;
    switch (o.startValue) {
      case Mr.min:
        ((l.value = l.min), c && (l.status = $e.increasing));
        break;
      case Mr.max:
        ((l.value = l.max), c && (l.status = $e.decreasing));
        break;
      case Mr.random:
      default:
        ((l.value = ut(l)),
          c && (l.status = se() >= qi ? $e.increasing : $e.decreasing));
        break;
    }
  }
  return ((l.initialValue = l.value), l);
}
function C1(n, e) {
  if (!(n.mode === En.percent)) {
    const { mode: l, ...u } = n;
    return u;
  }
  return "x" in n
    ? { x: (n.x / at) * e.width, y: (n.y / at) * e.height }
    : { width: (n.width / at) * e.width, height: (n.height / at) * e.height };
}
function w1(n, e) {
  return C1(n, e);
}
function rh(n, e) {
  return C1(n, e);
}
function Vp(n, e, r, o, l) {
  switch (e) {
    case pi.max:
      r >= l && n.destroy();
      break;
    case pi.min:
      r <= o && n.destroy();
      break;
  }
}
function la(n, e, r, o, l) {
  if (
    n.destroyed ||
    !e ||
    !e.enable ||
    ((e.maxLoops ?? 0) > 0 && (e.loops ?? 0) > (e.maxLoops ?? 0))
  )
    return;
  const g = (e.velocity ?? 0) * l.factor,
    v = e.min,
    C = e.max,
    x = e.decay ?? 1;
  if (
    (e.time || (e.time = 0),
    (e.delayTime ?? 0) > 0 &&
      e.time < (e.delayTime ?? 0) &&
      (e.time += l.value),
    !((e.delayTime ?? 0) > 0 && e.time < (e.delayTime ?? 0)))
  ) {
    switch (e.status) {
      case $e.increasing:
        e.value >= C
          ? (r ? (e.status = $e.decreasing) : (e.value -= C),
            e.loops || (e.loops = 0),
            e.loops++)
          : (e.value += g);
        break;
      case $e.decreasing:
        e.value <= v
          ? (r ? (e.status = $e.increasing) : (e.value += C),
            e.loops || (e.loops = 0),
            e.loops++)
          : (e.value -= g);
    }
    (e.velocity && x !== 1 && (e.velocity *= x),
      Vp(n, o, e.value, v, C),
      n.destroyed || (e.value = Yt(e.value, v, C)));
  }
}
function re(n, e) {
  if (n.version !== e)
    throw new Error(
      `The tsParticles version is different from the loaded plugins version. Engine version: ${n.version}. Plugins version: ${e}`,
    );
}
var li;
(function (n) {
  ((n.darken = "darken"), (n.enlighten = "enlighten"));
})(li || (li = {}));
const Ul = "random",
  Rl = "mid";
function Wp(n, e) {
  if (e) {
    for (const r of n.colorManagers.values())
      if (e.startsWith(r.stringPrefix)) return r.parseString(e);
  }
}
function Qt(n, e, r, o = !0) {
  if (!e) return;
  const l = hi(e) ? { value: e } : e;
  if (hi(l.value)) return x1(n, l.value, r, o);
  if (vt(l.value)) return Qt(n, { value: Yo(l.value, r, o) });
  for (const u of n.colorManagers.values()) {
    const c = u.handleRangeColor(l);
    if (c) return c;
  }
}
function x1(n, e, r, o = !0) {
  if (!e) return;
  const l = hi(e) ? { value: e } : e;
  if (hi(l.value)) return l.value === Ul ? b1() : qp(n, l.value);
  if (vt(l.value)) return x1(n, { value: Yo(l.value, r, o) });
  for (const u of n.colorManagers.values()) {
    const c = u.handleColor(l);
    if (c) return c;
  }
}
function mi(n, e, r, o = !0) {
  const l = Qt(n, e, r, o);
  return l ? _1(l) : void 0;
}
function _1(n) {
  const g = n.r / 255,
    v = n.g / 255,
    C = n.b / 255,
    x = Math.max(g, v, C),
    b = Math.min(g, v, C),
    _ = { h: 0, l: (x + b) * 0.5, s: 0 };
  return (
    x !== b &&
      ((_.s = _.l < 0.5 ? (x - b) / (x + b) : (x - b) / (2 - x - b)),
      (_.h =
        g === x
          ? (v - C) / (x - b)
          : (_.h =
              v === x ? 2 + (C - g) / (x - b) : 2 * 2 + (g - v) / (x - b)))),
    (_.l *= 100),
    (_.s *= 100),
    (_.h *= 60),
    _.h < 0 && (_.h += 360),
    _.h >= 360 && (_.h -= 360),
    _
  );
}
function qp(n, e) {
  return Wp(n, e);
}
function Br(n) {
  const c = ((n.h % 360) + 360) % 360,
    d = Math.max(0, Math.min(100, n.s)),
    p = Math.max(0, Math.min(100, n.l)),
    m = c / 360,
    g = d / 100,
    v = p / 100,
    C = 255,
    x = 3;
  if (d === 0) {
    const he = Math.round(v * C);
    return { r: he, g: he, b: he };
  }
  const b = 0.5,
    _ = 2,
    E = (he, _e, Se) => {
      if ((Se < 0 && Se++, Se > 1 && Se--, Se * 6 < 1))
        return he + (_e - he) * 6 * Se;
      if (Se * _ < 1) return _e;
      if (Se * x < 1 * _) {
        const qe = _ / x;
        return he + (_e - he) * (qe - Se) * 6;
      }
      return he;
    },
    T = 1,
    D = v < b ? v * (T + g) : v + g - v * g,
    I = _ * v - D,
    R = 1,
    N = R / x,
    F = Math.min(C, C * E(I, D, m + N)),
    V = Math.min(C, C * E(I, D, m)),
    ie = Math.min(C, C * E(I, D, m - N));
  return { r: Math.round(F), g: Math.round(V), b: Math.round(ie) };
}
function Gp(n) {
  const e = Br(n);
  return { a: n.a, b: e.b, g: e.g, r: e.r };
}
function b1(n) {
  return {
    b: Math.floor(ut(ee(0, 256))),
    g: Math.floor(ut(ee(0, 256))),
    r: Math.floor(ut(ee(0, 256))),
  };
}
function Sn(n, e) {
  return `rgba(${n.r}, ${n.g}, ${n.b}, ${e ?? 1})`;
}
function Ur(n, e) {
  return `hsla(${n.h}, ${n.s}%, ${n.l}%, ${e ?? 1})`;
}
function g3(n, e, r, o) {
  let l = n,
    u = e;
  return (
    l.r === void 0 && (l = Br(n)),
    u.r === void 0 && (u = Br(e)),
    { b: vc(l.b, u.b, r, o), g: vc(l.g, u.g, r, o), r: vc(l.r, u.r, r, o) }
  );
}
function Jc(n, e, r) {
  if (r === Ul) return b1();
  if (r === Rl) {
    const o = n.getFillColor() ?? n.getStrokeColor(),
      l =
        (e == null ? void 0 : e.getFillColor()) ??
        (e == null ? void 0 : e.getStrokeColor());
    if (o && l && e) return g3(o, l, n.getRadius(), e.getRadius());
    {
      const u = o ?? l;
      if (u) return Br(u);
    }
  } else return r;
}
function k1(n, e, r, o) {
  const l = hi(e) ? e : e.value;
  return l === Ul
    ? o
      ? Qt(n, { value: l })
      : r
        ? Ul
        : Rl
    : l === Rl
      ? Rl
      : Qt(n, { value: l });
}
function oh(n) {
  return n !== void 0 ? { h: n.h.value, s: n.s.value, l: n.l.value } : void 0;
}
function S1(n, e, r) {
  const o = {
    h: { enable: !1, value: n.h },
    s: { enable: !1, value: n.s },
    l: { enable: !1, value: n.l },
  };
  return (e && (Cc(o.h, e.h, r), Cc(o.s, e.s, r), Cc(o.l, e.l, r)), o);
}
function Cc(n, e, r) {
  n.enable = e.enable;
  const o = 0,
    l = 1,
    u = 0,
    c = 0;
  n.enable
    ? ((n.velocity = (H(e.speed) / at) * r),
      (n.decay = l - H(e.decay)),
      (n.status = $e.increasing),
      (n.loops = u),
      (n.maxLoops = H(e.count)),
      (n.time = c),
      (n.delayTime = H(e.delay) * Fe),
      e.sync || ((n.velocity *= se()), (n.value *= se())),
      (n.initialValue = n.value),
      (n.offset = ee(e.offset)))
    : (n.velocity = o);
}
function wc(n, e, r, o) {
  if (
    !n ||
    !n.enable ||
    ((n.maxLoops ?? 0) > 0 && (n.loops ?? 0) > (n.maxLoops ?? 0)) ||
    (n.time || (n.time = 0),
    (n.delayTime ?? 0) > 0 &&
      n.time < (n.delayTime ?? 0) &&
      (n.time += o.value),
    (n.delayTime ?? 0) > 0 && n.time < (n.delayTime ?? 0))
  )
    return;
  const g = n.offset ? ut(n.offset) : 0,
    v = (n.velocity ?? 0) * o.factor + g * 3.6,
    C = n.decay ?? 1,
    x = kn(e),
    b = sa(e);
  (!r || n.status === $e.increasing
    ? ((n.value += v),
      n.value > x &&
        (n.loops || (n.loops = 0),
        n.loops++,
        r ? (n.status = $e.decreasing) : (n.value -= x)))
    : ((n.value -= v),
      n.value < 0 &&
        (n.loops || (n.loops = 0), n.loops++, (n.status = $e.increasing))),
    n.velocity && C !== 1 && (n.velocity *= C),
    (n.value = Yt(n.value, b, x)));
}
function E1(n, e) {
  if (!n) return;
  const { h: r, s: o, l } = n,
    u = {
      h: { min: 0, max: 360 },
      s: { min: 0, max: 100 },
      l: { min: 0, max: 100 },
    };
  (r && wc(r, u.h, !1, e), o && wc(o, u.s, !0, e), l && wc(l, u.l, !0, e));
}
const Hr = { x: 0, y: 0 },
  hl = { a: 1, b: 0, c: 0, d: 1 };
function Vo(n, e, r) {
  (n.beginPath(), n.moveTo(e.x, e.y), n.lineTo(r.x, r.y), n.closePath());
}
function Qp(n, e, r) {
  ((n.fillStyle = r ?? "rgba(0,0,0,0)"),
    n.fillRect(Hr.x, Hr.y, e.width, e.height));
}
function Zp(n, e, r, o) {
  r &&
    ((n.globalAlpha = o),
    n.drawImage(r, Hr.x, Hr.y, e.width, e.height),
    (n.globalAlpha = 1));
}
function xc(n, e) {
  n.clearRect(Hr.x, Hr.y, e.width, e.height);
}
function Kp(n) {
  const {
      container: e,
      context: r,
      particle: o,
      delta: l,
      colorStyles: u,
      backgroundMask: c,
      composite: d,
      radius: p,
      opacity: m,
      shadow: g,
      transform: v,
    } = n,
    C = o.getPosition(),
    x = 0,
    b = o.rotation + (o.pathRotation ? o.velocity.angle : x),
    _ = { sin: Math.sin(b), cos: Math.cos(b) },
    E = !!b,
    T = 1,
    D = {
      a: _.cos * (v.a ?? hl.a),
      b: E ? _.sin * (v.b ?? T) : (v.b ?? hl.b),
      c: E ? -_.sin * (v.c ?? T) : (v.c ?? hl.c),
      d: _.cos * (v.d ?? hl.d),
    };
  (r.setTransform(D.a, D.b, D.c, D.d, C.x, C.y),
    c && (r.globalCompositeOperation = d));
  const I = o.shadowColor;
  (g.enable &&
    I &&
    ((r.shadowBlur = g.blur),
    (r.shadowColor = Sn(I)),
    (r.shadowOffsetX = g.offset.x),
    (r.shadowOffsetY = g.offset.y)),
    u.fill && (r.fillStyle = u.fill));
  const R = 0,
    N = o.strokeWidth ?? R;
  ((r.lineWidth = N), u.stroke && (r.strokeStyle = u.stroke));
  const F = {
    container: e,
    context: r,
    particle: o,
    radius: p,
    opacity: m,
    delta: l,
    transformData: D,
    strokeWidth: N,
  };
  (Xp(F),
    Jp(F),
    Yp(F),
    (r.globalCompositeOperation = "source-over"),
    r.resetTransform());
}
function Yp(n) {
  const {
    container: e,
    context: r,
    particle: o,
    radius: l,
    opacity: u,
    delta: c,
    transformData: d,
  } = n;
  if (!o.effect) return;
  const p = e.effectDrawers.get(o.effect);
  p &&
    p.draw({
      context: r,
      particle: o,
      radius: l,
      opacity: u,
      delta: c,
      pixelRatio: e.retina.pixelRatio,
      transformData: { ...d },
    });
}
function Xp(n) {
  const {
      container: e,
      context: r,
      particle: o,
      radius: l,
      opacity: u,
      delta: c,
      strokeWidth: d,
      transformData: p,
    } = n,
    m = 0;
  if (!o.shape) return;
  const g = e.shapeDrawers.get(o.shape);
  g &&
    (r.beginPath(),
    g.draw({
      context: r,
      particle: o,
      radius: l,
      opacity: u,
      delta: c,
      pixelRatio: e.retina.pixelRatio,
      transformData: { ...p },
    }),
    o.shapeClose && r.closePath(),
    d > m && r.stroke(),
    o.shapeFill && r.fill());
}
function Jp(n) {
  const {
    container: e,
    context: r,
    particle: o,
    radius: l,
    opacity: u,
    delta: c,
    transformData: d,
  } = n;
  if (!o.shape) return;
  const p = e.shapeDrawers.get(o.shape);
  p != null &&
    p.afterDraw &&
    p.afterDraw({
      context: r,
      particle: o,
      radius: l,
      opacity: u,
      delta: c,
      pixelRatio: e.retina.pixelRatio,
      transformData: { ...d },
    });
}
function e7(n, e, r) {
  e.draw && e.draw(n, r);
}
function t7(n, e, r, o) {
  e.drawParticle && e.drawParticle(n, r, o);
}
function n7(n, e, r) {
  return { h: n.h, s: n.s, l: n.l + (e === li.darken ? -1 : 1) * r };
}
function i7(n, e, r) {
  const o = e[r],
    l = 1;
  o !== void 0 && (n[r] = (n[r] ?? l) * o);
}
function sh(n, e, r = !1) {
  if (!e) return;
  const o = n;
  if (!o) return;
  const l = o.style;
  if (l)
    for (const u in e) {
      const c = e[u];
      l.setProperty(u, c, r ? "important" : "");
    }
}
class r7 {
  constructor(e, r) {
    ((this.container = e),
      (this._applyPostDrawUpdaters = (u) => {
        var c;
        for (const d of this._postDrawUpdaters)
          (c = d.afterDraw) == null || c.call(d, u);
      }),
      (this._applyPreDrawUpdaters = (u, c, d, p, m, g) => {
        var v;
        for (const C of this._preDrawUpdaters) {
          if (C.getColorStyles) {
            const { fill: x, stroke: b } = C.getColorStyles(c, u, d, p);
            (x && (m.fill = x), b && (m.stroke = b));
          }
          if (C.getTransformValues) {
            const x = C.getTransformValues(c);
            for (const b in x) i7(g, x, b);
          }
          (v = C.beforeDraw) == null || v.call(C, c);
        }
      }),
      (this._applyResizePlugins = () => {
        var u;
        for (const c of this._resizePlugins)
          (u = c.resize) == null || u.call(c);
      }),
      (this._getPluginParticleColors = (u) => {
        let c, d;
        for (const p of this._colorPlugins)
          if (
            (!c &&
              p.particleFillColor &&
              (c = mi(this._engine, p.particleFillColor(u))),
            !d &&
              p.particleStrokeColor &&
              (d = mi(this._engine, p.particleStrokeColor(u))),
            c && d)
          )
            break;
        return [c, d];
      }),
      (this._initCover = async () => {
        const u = this.container.actualOptions,
          c = u.backgroundMask.cover,
          d = c.color;
        if (d) {
          const p = Qt(this._engine, d);
          if (p) {
            const m = { ...p, a: c.opacity };
            this._coverColorStyle = Sn(m, m.a);
          }
        } else
          await new Promise((p, m) => {
            if (!c.image) return;
            const g = document.createElement("img");
            (g.addEventListener("load", () => {
              ((this._coverImage = { image: g, opacity: c.opacity }), p());
            }),
              g.addEventListener("error", (v) => {
                m(v.error);
              }),
              (g.src = c.image));
          });
      }),
      (this._initStyle = () => {
        const u = this.element,
          c = this.container.actualOptions;
        if (u) {
          this._fullScreen
            ? ((this._originalStyle = je({}, u.style)),
              this._setFullScreenStyle())
            : this._resetOriginalStyle();
          for (const d in c.style) {
            if (!d || !c.style) continue;
            const p = c.style[d];
            p && u.style.setProperty(d, p, "important");
          }
        }
      }),
      (this._initTrail = async () => {
        const u = this.container.actualOptions,
          c = u.particles.move.trail,
          d = c.fill;
        if (!c.enable) return;
        const p = 1,
          m = p / c.length;
        if (d.color) {
          const g = Qt(this._engine, d.color);
          if (!g) return;
          this._trailFill = { color: { ...g }, opacity: m };
        } else
          await new Promise((g, v) => {
            if (!d.image) return;
            const C = document.createElement("img");
            (C.addEventListener("load", () => {
              ((this._trailFill = { image: C, opacity: m }), g());
            }),
              C.addEventListener("error", (x) => {
                v(x.error);
              }),
              (C.src = d.image));
          });
      }),
      (this._paintBase = (u) => {
        this.draw((c) => Qp(c, this.size, u));
      }),
      (this._paintImage = (u, c) => {
        this.draw((d) => Zp(d, this.size, u, c));
      }),
      (this._repairStyle = () => {
        const u = this.element;
        u &&
          (this._safeMutationObserver((c) => c.disconnect()),
          this._initStyle(),
          this.initBackground(),
          this._safeMutationObserver((c) => {
            !u || !(u instanceof Node) || c.observe(u, { attributes: !0 });
          }));
      }),
      (this._resetOriginalStyle = () => {
        const u = this.element,
          c = this._originalStyle;
        u && c && sh(u, c);
      }),
      (this._safeMutationObserver = (u) => {
        this._mutationObserver && u(this._mutationObserver);
      }),
      (this._setFullScreenStyle = () => {
        const u = this.element;
        if (!u) return;
        const c = 10,
          d = this.container.actualOptions.fullScreen.zIndex.toString(c);
        sh(
          u,
          {
            position: "fixed",
            "z-index": d,
            zIndex: d,
            top: "0",
            left: "0",
            width: "100%",
            height: "100%",
          },
          !0,
        );
      }),
      (this._engine = r),
      (this._standardSize = { height: 0, width: 0 }));
    const o = e.retina.pixelRatio,
      l = this._standardSize;
    ((this.size = { height: l.height * o, width: l.width * o }),
      (this._context = null),
      (this._generated = !1),
      (this._preDrawUpdaters = []),
      (this._postDrawUpdaters = []),
      (this._resizePlugins = []),
      (this._colorPlugins = []));
  }
  get _fullScreen() {
    return this.container.actualOptions.fullScreen.enable;
  }
  clear() {
    const e = this.container.actualOptions,
      r = e.particles.move.trail,
      o = this._trailFill;
    e.backgroundMask.enable
      ? this.paint()
      : r.enable && r.length > 0 && o
        ? o.color
          ? this._paintBase(Sn(o.color, o.opacity))
          : o.image && this._paintImage(o.image, o.opacity)
        : e.clear &&
          this.draw((u) => {
            xc(u, this.size);
          });
  }
  destroy() {
    if ((this.stop(), this._generated)) {
      const e = this.element;
      e == null || e.remove();
    } else this._resetOriginalStyle();
    ((this._preDrawUpdaters = []),
      (this._postDrawUpdaters = []),
      (this._resizePlugins = []),
      (this._colorPlugins = []));
  }
  draw(e) {
    const r = this._context;
    if (r) return e(r);
  }
  drawAsync(e) {
    const r = this._context;
    if (r) return e(r);
  }
  drawParticle(e, r) {
    if (e.spawning || e.destroyed) return;
    const o = e.getRadius();
    if (o <= 0) return;
    const u = e.getFillColor(),
      c = e.getStrokeColor() ?? u;
    let [d, p] = this._getPluginParticleColors(e);
    (d || (d = u),
      p || (p = c),
      !(!d && !p) &&
        this.draw((m) => {
          var V;
          const g = this.container,
            v = g.actualOptions,
            C = e.options.zIndex,
            x = 1,
            b = x - e.zIndexFactor,
            _ = b ** C.opacityRate,
            E = 1,
            T =
              e.bubble.opacity ??
              ((V = e.opacity) == null ? void 0 : V.value) ??
              E,
            D = e.strokeOpacity ?? T,
            I = T * _,
            R = D * _,
            N = {},
            F = { fill: d ? Ur(d, I) : void 0 };
          ((F.stroke = p ? Ur(p, R) : F.fill),
            this._applyPreDrawUpdaters(m, e, o, I, F, N),
            Kp({
              container: g,
              context: m,
              particle: e,
              delta: r,
              colorStyles: F,
              backgroundMask: v.backgroundMask.enable,
              composite: v.backgroundMask.composite,
              radius: o * b ** C.sizeRate,
              opacity: I,
              shadow: e.options.shadow,
              transform: N,
            }),
            this._applyPostDrawUpdaters(e));
        }));
  }
  drawParticlePlugin(e, r, o) {
    this.draw((l) => t7(l, e, r, o));
  }
  drawPlugin(e, r) {
    this.draw((o) => e7(o, e, r));
  }
  async init() {
    (this._safeMutationObserver((e) => e.disconnect()),
      (this._mutationObserver = jp((e) => {
        for (const r of e)
          r.type === "attributes" &&
            r.attributeName === "style" &&
            this._repairStyle();
      })),
      this.resize(),
      this._initStyle(),
      await this._initCover());
    try {
      await this._initTrail();
    } catch (e) {
      Gi().error(e);
    }
    (this.initBackground(),
      this._safeMutationObserver((e) => {
        !this.element ||
          !(this.element instanceof Node) ||
          e.observe(this.element, { attributes: !0 });
      }),
      this.initUpdaters(),
      this.initPlugins(),
      this.paint());
  }
  initBackground() {
    const e = this.container.actualOptions,
      r = e.background,
      o = this.element;
    if (!o) return;
    const l = o.style;
    if (l) {
      if (r.color) {
        const u = Qt(this._engine, r.color);
        l.backgroundColor = u ? Sn(u, r.opacity) : "";
      } else l.backgroundColor = "";
      ((l.backgroundImage = r.image || ""),
        (l.backgroundPosition = r.position || ""),
        (l.backgroundRepeat = r.repeat || ""),
        (l.backgroundSize = r.size || ""));
    }
  }
  initPlugins() {
    this._resizePlugins = [];
    for (const e of this.container.plugins.values())
      (e.resize && this._resizePlugins.push(e),
        (e.particleFillColor ?? e.particleStrokeColor) &&
          this._colorPlugins.push(e));
  }
  initUpdaters() {
    ((this._preDrawUpdaters = []), (this._postDrawUpdaters = []));
    for (const e of this.container.particles.updaters)
      (e.afterDraw && this._postDrawUpdaters.push(e),
        (e.getColorStyles ?? e.getTransformValues ?? e.beforeDraw) &&
          this._preDrawUpdaters.push(e));
  }
  loadCanvas(e) {
    (this._generated && this.element && this.element.remove(),
      (this._generated =
        e.dataset && Fi in e.dataset
          ? e.dataset[Fi] === "true"
          : this._generated),
      (this.element = e),
      (this.element.ariaHidden = "true"),
      (this._originalStyle = je({}, this.element.style)));
    const r = this._standardSize;
    ((r.height = e.offsetHeight), (r.width = e.offsetWidth));
    const o = this.container.retina.pixelRatio,
      l = this.size;
    ((e.height = l.height = r.height * o),
      (e.width = l.width = r.width * o),
      (this._context = this.element.getContext("2d")),
      this._safeMutationObserver((u) => {
        !this.element ||
          !(this.element instanceof Node) ||
          u.observe(this.element, { attributes: !0 });
      }),
      this.container.retina.init(),
      this.initBackground());
  }
  paint() {
    const e = this.container.actualOptions;
    this.draw((r) => {
      e.backgroundMask.enable && e.backgroundMask.cover
        ? (xc(r, this.size),
          this._coverImage
            ? this._paintImage(this._coverImage.image, this._coverImage.opacity)
            : this._coverColorStyle
              ? this._paintBase(this._coverColorStyle)
              : this._paintBase())
        : this._paintBase();
    });
  }
  resize() {
    if (!this.element) return !1;
    const e = this.container,
      r = e.canvas._standardSize,
      o = {
        width: this.element.offsetWidth,
        height: this.element.offsetHeight,
      },
      l = e.retina.pixelRatio,
      u = { width: o.width * l, height: o.height * l };
    if (
      o.height === r.height &&
      o.width === r.width &&
      u.height === this.element.height &&
      u.width === this.element.width
    )
      return !1;
    const c = { ...r };
    ((r.height = o.height), (r.width = o.width));
    const d = this.size;
    return (
      (this.element.width = d.width = u.width),
      (this.element.height = d.height = u.height),
      this.container.started &&
        e.particles.setResizeFactor({
          width: r.width / c.width,
          height: r.height / c.height,
        }),
      !0
    );
  }
  stop() {
    (this._safeMutationObserver((e) => e.disconnect()),
      (this._mutationObserver = void 0),
      this.draw((e) => xc(e, this.size)));
  }
  async windowResize() {
    if (!this.element || !this.resize()) return;
    const e = this.container,
      r = e.updateActualOptions();
    (e.particles.setDensity(),
      this._applyResizePlugins(),
      r && (await e.refresh()));
  }
}
var Rr;
(function (n) {
  ((n.canvas = "canvas"), (n.parent = "parent"), (n.window = "window"));
})(Rr || (Rr = {}));
const lh = 2;
function Gt(n, e, r, o, l) {
  if (o) {
    let u = { passive: !0 };
    (a1(l) ? (u.capture = l) : l !== void 0 && (u = l),
      n.addEventListener(e, r, u));
  } else {
    const u = l;
    n.removeEventListener(e, r, u);
  }
}
class o7 {
  constructor(e) {
    ((this.container = e),
      (this._doMouseTouchClick = (r) => {
        const o = this.container,
          l = o.actualOptions;
        if (this._canPush) {
          const u = o.interactivity.mouse,
            c = u.position;
          if (!c) return;
          ((u.clickPosition = { ...c }), (u.clickTime = new Date().getTime()));
          const d = l.interactivity.events.onClick;
          Ke(d.mode, (p) => this.container.handleClickMode(p));
        }
        r.type === "touchend" &&
          setTimeout(() => this._mouseTouchFinish(), 500);
      }),
      (this._handleThemeChange = (r) => {
        const o = r,
          l = this.container,
          u = l.options,
          c = u.defaultThemes,
          d = o.matches ? c.dark : c.light,
          p = u.themes.find((m) => m.name === d);
        p != null && p.default.auto && l.loadTheme(d);
      }),
      (this._handleVisibilityChange = () => {
        const r = this.container,
          o = r.actualOptions;
        (this._mouseTouchFinish(),
          o.pauseOnBlur &&
            (document != null && document.hidden
              ? ((r.pageHidden = !0), r.pause())
              : ((r.pageHidden = !1),
                r.animationStatus ? r.play(!0) : r.draw(!0))));
      }),
      (this._handleWindowResize = () => {
        this._resizeTimeout &&
          (clearTimeout(this._resizeTimeout), delete this._resizeTimeout);
        const r = async () => {
          const o = this.container.canvas;
          await (o == null ? void 0 : o.windowResize());
        };
        this._resizeTimeout = setTimeout(
          () => void r(),
          this.container.actualOptions.interactivity.events.resize.delay * Fe,
        );
      }),
      (this._manageInteractivityListeners = (r, o) => {
        const l = this._handlers,
          u = this.container,
          c = u.actualOptions,
          d = u.interactivity.element;
        if (!d) return;
        const p = d,
          m = u.canvas.element;
        (m && (m.style.pointerEvents = p === m ? "initial" : "none"),
          (c.interactivity.events.onHover.enable ||
            c.interactivity.events.onClick.enable) &&
            (Gt(d, Wi, l.mouseMove, o),
            Gt(d, _p, l.touchStart, o),
            Gt(d, bp, l.touchMove, o),
            c.interactivity.events.onClick.enable
              ? (Gt(d, eh, l.touchEndClick, o),
                Gt(d, wp, l.mouseUp, o),
                Gt(d, Cp, l.mouseDown, o))
              : Gt(d, eh, l.touchEnd, o),
            Gt(d, r, l.mouseLeave, o),
            Gt(d, kp, l.touchCancel, o)));
      }),
      (this._manageListeners = (r) => {
        const o = this._handlers,
          l = this.container,
          u = l.actualOptions,
          c = u.interactivity.detectsOn,
          d = l.canvas.element;
        let p = Kc;
        (c === Rr.window
          ? ((l.interactivity.element = window), (p = xp))
          : c === Rr.parent && d
            ? (l.interactivity.element = d.parentElement ?? d.parentNode)
            : (l.interactivity.element = d),
          this._manageMediaMatch(r),
          this._manageResize(r),
          this._manageInteractivityListeners(p, r),
          document && Gt(document, Ep, o.visibilityChange, r, !1));
      }),
      (this._manageMediaMatch = (r) => {
        const o = this._handlers,
          l = h1("(prefers-color-scheme: dark)");
        if (l) {
          if (l.addEventListener !== void 0) {
            Gt(l, "change", o.themeChange, r);
            return;
          }
          l.addListener !== void 0 &&
            (r
              ? l.addListener(o.oldThemeChange)
              : l.removeListener(o.oldThemeChange));
        }
      }),
      (this._manageResize = (r) => {
        const o = this._handlers,
          l = this.container;
        if (!l.actualOptions.interactivity.events.resize) return;
        if (typeof ResizeObserver > "u") {
          Gt(window, Sp, o.resize, r);
          return;
        }
        const c = l.canvas.element;
        this._resizeObserver && !r
          ? (c && this._resizeObserver.unobserve(c),
            this._resizeObserver.disconnect(),
            delete this._resizeObserver)
          : !this._resizeObserver &&
            r &&
            c &&
            ((this._resizeObserver = new ResizeObserver((d) => {
              d.find((m) => m.target === c) && this._handleWindowResize();
            })),
            this._resizeObserver.observe(c));
      }),
      (this._mouseDown = () => {
        const { interactivity: r } = this.container;
        if (!r) return;
        const { mouse: o } = r;
        ((o.clicking = !0), (o.downPosition = o.position));
      }),
      (this._mouseTouchClick = (r) => {
        const o = this.container,
          l = o.actualOptions,
          { mouse: u } = o.interactivity;
        u.inside = !0;
        let c = !1;
        const d = u.position;
        if (!(!d || !l.interactivity.events.onClick.enable)) {
          for (const p of o.plugins.values())
            if (p.clickPositionValid && ((c = p.clickPositionValid(d)), c))
              break;
          (c || this._doMouseTouchClick(r), (u.clicking = !1));
        }
      }),
      (this._mouseTouchFinish = () => {
        const r = this.container.interactivity;
        if (!r) return;
        const o = r.mouse;
        (delete o.position,
          delete o.clickPosition,
          delete o.downPosition,
          (r.status = Kc),
          (o.inside = !1),
          (o.clicking = !1));
      }),
      (this._mouseTouchMove = (r) => {
        const o = this.container,
          l = o.actualOptions,
          u = o.interactivity,
          c = o.canvas.element;
        if (!(u != null && u.element)) return;
        u.mouse.inside = !0;
        let d;
        if (r.type.startsWith("pointer")) {
          this._canPush = !0;
          const m = r;
          if (u.element === window) {
            if (c) {
              const g = c.getBoundingClientRect();
              d = { x: m.clientX - g.left, y: m.clientY - g.top };
            }
          } else if (l.interactivity.detectsOn === Rr.parent) {
            const g = m.target,
              v = m.currentTarget;
            if (g && v && c) {
              const C = g.getBoundingClientRect(),
                x = v.getBoundingClientRect(),
                b = c.getBoundingClientRect();
              d = {
                x: m.offsetX + lh * C.left - (x.left + b.left),
                y: m.offsetY + lh * C.top - (x.top + b.top),
              };
            } else d = { x: m.offsetX ?? m.clientX, y: m.offsetY ?? m.clientY };
          } else
            m.target === c &&
              (d = { x: m.offsetX ?? m.clientX, y: m.offsetY ?? m.clientY });
        } else if (((this._canPush = r.type !== "touchmove"), c)) {
          const m = r,
            g = 1,
            v = m.touches[m.touches.length - g],
            C = c.getBoundingClientRect(),
            x = 0;
          d = { x: v.clientX - (C.left ?? x), y: v.clientY - (C.top ?? x) };
        }
        const p = o.retina.pixelRatio;
        (d && ((d.x *= p), (d.y *= p)),
          (u.mouse.position = d),
          (u.status = Wi));
      }),
      (this._touchEnd = (r) => {
        const o = r,
          l = Array.from(o.changedTouches);
        for (const u of l) this._touches.delete(u.identifier);
        this._mouseTouchFinish();
      }),
      (this._touchEndClick = (r) => {
        const o = r,
          l = Array.from(o.changedTouches);
        for (const u of l) this._touches.delete(u.identifier);
        this._mouseTouchClick(r);
      }),
      (this._touchStart = (r) => {
        const o = r,
          l = Array.from(o.changedTouches);
        for (const u of l) this._touches.set(u.identifier, performance.now());
        this._mouseTouchMove(r);
      }),
      (this._canPush = !0),
      (this._touches = new Map()),
      (this._handlers = {
        mouseDown: () => this._mouseDown(),
        mouseLeave: () => this._mouseTouchFinish(),
        mouseMove: (r) => this._mouseTouchMove(r),
        mouseUp: (r) => this._mouseTouchClick(r),
        touchStart: (r) => this._touchStart(r),
        touchMove: (r) => this._mouseTouchMove(r),
        touchEnd: (r) => this._touchEnd(r),
        touchCancel: (r) => this._touchEnd(r),
        touchEndClick: (r) => this._touchEndClick(r),
        visibilityChange: () => this._handleVisibilityChange(),
        themeChange: (r) => this._handleThemeChange(r),
        oldThemeChange: (r) => this._handleThemeChange(r),
        resize: () => {
          this._handleWindowResize();
        },
      }));
  }
  addListeners() {
    this._manageListeners(!0);
  }
  removeListeners() {
    this._manageListeners(!1);
  }
}
var bt;
(function (n) {
  ((n.configAdded = "configAdded"),
    (n.containerInit = "containerInit"),
    (n.particlesSetup = "particlesSetup"),
    (n.containerStarted = "containerStarted"),
    (n.containerStopped = "containerStopped"),
    (n.containerDestroyed = "containerDestroyed"),
    (n.containerPaused = "containerPaused"),
    (n.containerPlay = "containerPlay"),
    (n.containerBuilt = "containerBuilt"),
    (n.particleAdded = "particleAdded"),
    (n.particleDestroyed = "particleDestroyed"),
    (n.particleRemoved = "particleRemoved"));
})(bt || (bt = {}));
class Ve {
  constructor() {
    this.value = "";
  }
  static create(e, r) {
    const o = new Ve();
    return (
      o.load(e),
      r !== void 0 && (hi(r) || vt(r) ? o.load({ value: r }) : o.load(r)),
      o
    );
  }
  load(e) {
    $(e) || $(e.value) || (this.value = e.value);
  }
}
class s7 {
  constructor() {
    ((this.color = new Ve()),
      (this.color.value = ""),
      (this.image = ""),
      (this.position = ""),
      (this.repeat = ""),
      (this.size = ""),
      (this.opacity = 1));
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.image !== void 0 && (this.image = e.image),
      e.position !== void 0 && (this.position = e.position),
      e.repeat !== void 0 && (this.repeat = e.repeat),
      e.size !== void 0 && (this.size = e.size),
      e.opacity !== void 0 && (this.opacity = e.opacity));
  }
}
class l7 {
  constructor() {
    this.opacity = 1;
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.image !== void 0 && (this.image = e.image),
      e.opacity !== void 0 && (this.opacity = e.opacity));
  }
}
class a7 {
  constructor() {
    ((this.composite = "destination-out"),
      (this.cover = new l7()),
      (this.enable = !1));
  }
  load(e) {
    if (!$(e)) {
      if (
        (e.composite !== void 0 && (this.composite = e.composite),
        e.cover !== void 0)
      ) {
        const r = e.cover,
          o = hi(e.cover) ? { color: e.cover } : e.cover;
        this.cover.load(
          r.color !== void 0 || r.image !== void 0 ? r : { color: o },
        );
      }
      e.enable !== void 0 && (this.enable = e.enable);
    }
  }
}
class u7 {
  constructor() {
    ((this.enable = !0), (this.zIndex = 0));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.zIndex !== void 0 && (this.zIndex = e.zIndex));
  }
}
class c7 {
  constructor() {
    ((this.enable = !1), (this.mode = []));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.mode !== void 0 && (this.mode = e.mode));
  }
}
var Vr;
(function (n) {
  ((n.circle = "circle"), (n.rectangle = "rectangle"));
})(Vr || (Vr = {}));
class ah {
  constructor() {
    ((this.selectors = []),
      (this.enable = !1),
      (this.mode = []),
      (this.type = Vr.circle));
  }
  load(e) {
    $(e) ||
      (e.selectors !== void 0 && (this.selectors = e.selectors),
      e.enable !== void 0 && (this.enable = e.enable),
      e.mode !== void 0 && (this.mode = e.mode),
      e.type !== void 0 && (this.type = e.type));
  }
}
class f7 {
  constructor() {
    ((this.enable = !1), (this.force = 2), (this.smooth = 10));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.force !== void 0 && (this.force = e.force),
      e.smooth !== void 0 && (this.smooth = e.smooth));
  }
}
class d7 {
  constructor() {
    ((this.enable = !1), (this.mode = []), (this.parallax = new f7()));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.mode !== void 0 && (this.mode = e.mode),
      this.parallax.load(e.parallax));
  }
}
class h7 {
  constructor() {
    ((this.delay = 0.5), (this.enable = !0));
  }
  load(e) {
    $(e) ||
      (e.delay !== void 0 && (this.delay = e.delay),
      e.enable !== void 0 && (this.enable = e.enable));
  }
}
class p7 {
  constructor() {
    ((this.onClick = new c7()),
      (this.onDiv = new ah()),
      (this.onHover = new d7()),
      (this.resize = new h7()));
  }
  load(e) {
    if ($(e)) return;
    this.onClick.load(e.onClick);
    const r = e.onDiv;
    (r !== void 0 &&
      (this.onDiv = Ke(r, (o) => {
        const l = new ah();
        return (l.load(o), l);
      })),
      this.onHover.load(e.onHover),
      this.resize.load(e.resize));
  }
}
class m7 {
  constructor(e, r) {
    ((this._engine = e), (this._container = r));
  }
  load(e) {
    if ($(e) || !this._container) return;
    const r = this._engine.interactors.get(this._container);
    if (r) for (const o of r) o.loadModeOptions && o.loadModeOptions(this, e);
  }
}
class P1 {
  constructor(e, r) {
    ((this.detectsOn = Rr.window),
      (this.events = new p7()),
      (this.modes = new m7(e, r)));
  }
  load(e) {
    if ($(e)) return;
    const r = e.detectsOn;
    (r !== void 0 && (this.detectsOn = r),
      this.events.load(e.events),
      this.modes.load(e.modes));
  }
}
const uh = 50;
class y7 {
  load(e) {
    $(e) ||
      (e.position &&
        (this.position = {
          x: e.position.x ?? uh,
          y: e.position.y ?? uh,
          mode: e.position.mode ?? En.percent,
        }),
      e.options && (this.options = je({}, e.options)));
  }
}
var Ni;
(function (n) {
  ((n.screen = "screen"), (n.canvas = "canvas"));
})(Ni || (Ni = {}));
class g7 {
  constructor() {
    ((this.maxWidth = 1 / 0), (this.options = {}), (this.mode = Ni.canvas));
  }
  load(e) {
    $(e) ||
      ($(e.maxWidth) || (this.maxWidth = e.maxWidth),
      $(e.mode) ||
        (e.mode === Ni.screen
          ? (this.mode = Ni.screen)
          : (this.mode = Ni.canvas)),
      $(e.options) || (this.options = je({}, e.options)));
  }
}
var ai;
(function (n) {
  ((n.any = "any"), (n.dark = "dark"), (n.light = "light"));
})(ai || (ai = {}));
class v7 {
  constructor() {
    ((this.auto = !1), (this.mode = ai.any), (this.value = !1));
  }
  load(e) {
    $(e) ||
      (e.auto !== void 0 && (this.auto = e.auto),
      e.mode !== void 0 && (this.mode = e.mode),
      e.value !== void 0 && (this.value = e.value));
  }
}
class C7 {
  constructor() {
    ((this.name = ""), (this.default = new v7()));
  }
  load(e) {
    $(e) ||
      (e.name !== void 0 && (this.name = e.name),
      this.default.load(e.default),
      e.options !== void 0 && (this.options = je({}, e.options)));
  }
}
class v3 {
  constructor() {
    ((this.count = 0),
      (this.enable = !1),
      (this.speed = 1),
      (this.decay = 0),
      (this.delay = 0),
      (this.sync = !1));
  }
  load(e) {
    $(e) ||
      (e.count !== void 0 && (this.count = ee(e.count)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.speed !== void 0 && (this.speed = ee(e.speed)),
      e.decay !== void 0 && (this.decay = ee(e.decay)),
      e.delay !== void 0 && (this.delay = ee(e.delay)),
      e.sync !== void 0 && (this.sync = e.sync));
  }
}
class C3 extends v3 {
  constructor() {
    (super(), (this.mode = Ai.auto), (this.startValue = Mr.random));
  }
  load(e) {
    (super.load(e),
      !$(e) &&
        (e.mode !== void 0 && (this.mode = e.mode),
        e.startValue !== void 0 && (this.startValue = e.startValue)));
  }
}
class _c extends v3 {
  constructor() {
    (super(), (this.offset = 0), (this.sync = !0));
  }
  load(e) {
    (super.load(e),
      !$(e) && e.offset !== void 0 && (this.offset = ee(e.offset)));
  }
}
class w7 {
  constructor() {
    ((this.h = new _c()), (this.s = new _c()), (this.l = new _c()));
  }
  load(e) {
    $(e) || (this.h.load(e.h), this.s.load(e.s), this.l.load(e.l));
  }
}
class Wr extends Ve {
  constructor() {
    (super(), (this.animation = new w7()));
  }
  static create(e, r) {
    const o = new Wr();
    return (
      o.load(e),
      r !== void 0 && (hi(r) || vt(r) ? o.load({ value: r }) : o.load(r)),
      o
    );
  }
  load(e) {
    if ((super.load(e), $(e))) return;
    const r = e.animation;
    r !== void 0 &&
      (r.enable !== void 0
        ? this.animation.h.load(r)
        : this.animation.load(e.animation));
  }
}
var Dr;
(function (n) {
  ((n.absorb = "absorb"), (n.bounce = "bounce"), (n.destroy = "destroy"));
})(Dr || (Dr = {}));
class x7 {
  constructor() {
    this.speed = 2;
  }
  load(e) {
    $(e) || (e.speed !== void 0 && (this.speed = e.speed));
  }
}
class _7 {
  constructor() {
    ((this.enable = !0), (this.retries = 0));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.retries !== void 0 && (this.retries = e.retries));
  }
}
class hn {
  constructor() {
    this.value = 0;
  }
  load(e) {
    $(e) || $(e.value) || (this.value = ee(e.value));
  }
}
class b7 extends hn {
  constructor() {
    (super(), (this.animation = new v3()));
  }
  load(e) {
    if ((super.load(e), $(e))) return;
    const r = e.animation;
    r !== void 0 && this.animation.load(r);
  }
}
class z1 extends b7 {
  constructor() {
    (super(), (this.animation = new C3()));
  }
  load(e) {
    super.load(e);
  }
}
class ch extends hn {
  constructor() {
    (super(), (this.value = 1));
  }
}
class O1 {
  constructor() {
    ((this.horizontal = new ch()), (this.vertical = new ch()));
  }
  load(e) {
    $(e) ||
      (this.horizontal.load(e.horizontal), this.vertical.load(e.vertical));
  }
}
class k7 {
  constructor() {
    ((this.absorb = new x7()),
      (this.bounce = new O1()),
      (this.enable = !1),
      (this.maxSpeed = 50),
      (this.mode = Dr.bounce),
      (this.overlap = new _7()));
  }
  load(e) {
    $(e) ||
      (this.absorb.load(e.absorb),
      this.bounce.load(e.bounce),
      e.enable !== void 0 && (this.enable = e.enable),
      e.maxSpeed !== void 0 && (this.maxSpeed = ee(e.maxSpeed)),
      e.mode !== void 0 && (this.mode = e.mode),
      this.overlap.load(e.overlap));
  }
}
class S7 {
  constructor() {
    ((this.close = !0),
      (this.fill = !0),
      (this.options = {}),
      (this.type = []));
  }
  load(e) {
    if ($(e)) return;
    const r = e.options;
    if (r !== void 0)
      for (const o in r) {
        const l = r[o];
        l && (this.options[o] = je(this.options[o] ?? {}, l));
      }
    (e.close !== void 0 && (this.close = e.close),
      e.fill !== void 0 && (this.fill = e.fill),
      e.type !== void 0 && (this.type = e.type));
  }
}
class E7 {
  constructor() {
    ((this.offset = 0), (this.value = 90));
  }
  load(e) {
    $(e) ||
      (e.offset !== void 0 && (this.offset = ee(e.offset)),
      e.value !== void 0 && (this.value = ee(e.value)));
  }
}
class P7 {
  constructor() {
    ((this.distance = 200),
      (this.enable = !1),
      (this.rotate = { x: 3e3, y: 3e3 }));
  }
  load(e) {
    if (
      !$(e) &&
      (e.distance !== void 0 && (this.distance = ee(e.distance)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.rotate)
    ) {
      const r = e.rotate.x;
      r !== void 0 && (this.rotate.x = r);
      const o = e.rotate.y;
      o !== void 0 && (this.rotate.y = o);
    }
  }
}
class z7 {
  constructor() {
    ((this.x = 50), (this.y = 50), (this.mode = En.percent), (this.radius = 0));
  }
  load(e) {
    $(e) ||
      (e.x !== void 0 && (this.x = e.x),
      e.y !== void 0 && (this.y = e.y),
      e.mode !== void 0 && (this.mode = e.mode),
      e.radius !== void 0 && (this.radius = e.radius));
  }
}
class O7 {
  constructor() {
    ((this.acceleration = 9.81),
      (this.enable = !1),
      (this.inverse = !1),
      (this.maxSpeed = 50));
  }
  load(e) {
    $(e) ||
      (e.acceleration !== void 0 && (this.acceleration = ee(e.acceleration)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.inverse !== void 0 && (this.inverse = e.inverse),
      e.maxSpeed !== void 0 && (this.maxSpeed = ee(e.maxSpeed)));
  }
}
class M7 {
  constructor() {
    ((this.clamp = !0),
      (this.delay = new hn()),
      (this.enable = !1),
      (this.options = {}));
  }
  load(e) {
    $(e) ||
      (e.clamp !== void 0 && (this.clamp = e.clamp),
      this.delay.load(e.delay),
      e.enable !== void 0 && (this.enable = e.enable),
      (this.generator = e.generator),
      e.options && (this.options = je(this.options, e.options)));
  }
}
class R7 {
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.image !== void 0 && (this.image = e.image));
  }
}
class D7 {
  constructor() {
    ((this.enable = !1), (this.length = 10), (this.fill = new R7()));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.fill !== void 0 && this.fill.load(e.fill),
      e.length !== void 0 && (this.length = e.length));
  }
}
var Ze;
(function (n) {
  ((n.bounce = "bounce"),
    (n.none = "none"),
    (n.out = "out"),
    (n.destroy = "destroy"),
    (n.split = "split"));
})(Ze || (Ze = {}));
class T7 {
  constructor() {
    this.default = Ze.out;
  }
  load(e) {
    $(e) ||
      (e.default !== void 0 && (this.default = e.default),
      (this.bottom = e.bottom ?? e.default),
      (this.left = e.left ?? e.default),
      (this.right = e.right ?? e.default),
      (this.top = e.top ?? e.default));
  }
}
class I7 {
  constructor() {
    ((this.acceleration = 0), (this.enable = !1));
  }
  load(e) {
    $(e) ||
      (e.acceleration !== void 0 && (this.acceleration = ee(e.acceleration)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.position && (this.position = je({}, e.position)));
  }
}
class L7 {
  constructor() {
    ((this.angle = new E7()),
      (this.attract = new P7()),
      (this.center = new z7()),
      (this.decay = 0),
      (this.distance = {}),
      (this.direction = lt.none),
      (this.drift = 0),
      (this.enable = !1),
      (this.gravity = new O7()),
      (this.path = new M7()),
      (this.outModes = new T7()),
      (this.random = !1),
      (this.size = !1),
      (this.speed = 2),
      (this.spin = new I7()),
      (this.straight = !1),
      (this.trail = new D7()),
      (this.vibrate = !1),
      (this.warp = !1));
  }
  load(e) {
    if ($(e)) return;
    (this.angle.load(jt(e.angle) ? { value: e.angle } : e.angle),
      this.attract.load(e.attract),
      this.center.load(e.center),
      e.decay !== void 0 && (this.decay = ee(e.decay)),
      e.direction !== void 0 && (this.direction = e.direction),
      e.distance !== void 0 &&
        (this.distance = jt(e.distance)
          ? { horizontal: e.distance, vertical: e.distance }
          : { ...e.distance }),
      e.drift !== void 0 && (this.drift = ee(e.drift)),
      e.enable !== void 0 && (this.enable = e.enable),
      this.gravity.load(e.gravity));
    const r = e.outModes;
    (r !== void 0 &&
      (Er(r) ? this.outModes.load(r) : this.outModes.load({ default: r })),
      this.path.load(e.path),
      e.random !== void 0 && (this.random = e.random),
      e.size !== void 0 && (this.size = e.size),
      e.speed !== void 0 && (this.speed = ee(e.speed)),
      this.spin.load(e.spin),
      e.straight !== void 0 && (this.straight = e.straight),
      this.trail.load(e.trail),
      e.vibrate !== void 0 && (this.vibrate = e.vibrate),
      e.warp !== void 0 && (this.warp = e.warp));
  }
}
class F7 extends C3 {
  constructor() {
    (super(), (this.destroy = pi.none), (this.speed = 2));
  }
  load(e) {
    (super.load(e),
      !$(e) && e.destroy !== void 0 && (this.destroy = e.destroy));
  }
}
class A7 extends z1 {
  constructor() {
    (super(), (this.animation = new F7()), (this.value = 1));
  }
  load(e) {
    if ($(e)) return;
    super.load(e);
    const r = e.animation;
    r !== void 0 && this.animation.load(r);
  }
}
class N7 {
  constructor() {
    ((this.enable = !1), (this.width = 1920), (this.height = 1080));
  }
  load(e) {
    if ($(e)) return;
    e.enable !== void 0 && (this.enable = e.enable);
    const r = e.width;
    r !== void 0 && (this.width = r);
    const o = e.height;
    o !== void 0 && (this.height = o);
  }
}
var Zo;
(function (n) {
  ((n.delete = "delete"), (n.wait = "wait"));
})(Zo || (Zo = {}));
class $7 {
  constructor() {
    ((this.mode = Zo.delete), (this.value = 0));
  }
  load(e) {
    $(e) ||
      (e.mode !== void 0 && (this.mode = e.mode),
      e.value !== void 0 && (this.value = e.value));
  }
}
class j7 {
  constructor() {
    ((this.density = new N7()), (this.limit = new $7()), (this.value = 0));
  }
  load(e) {
    $(e) ||
      (this.density.load(e.density),
      this.limit.load(e.limit),
      e.value !== void 0 && (this.value = e.value));
  }
}
class B7 {
  constructor() {
    ((this.blur = 0),
      (this.color = new Ve()),
      (this.enable = !1),
      (this.offset = { x: 0, y: 0 }),
      (this.color.value = "#000"));
  }
  load(e) {
    $(e) ||
      (e.blur !== void 0 && (this.blur = e.blur),
      (this.color = Ve.create(this.color, e.color)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.offset !== void 0 &&
        (e.offset.x !== void 0 && (this.offset.x = e.offset.x),
        e.offset.y !== void 0 && (this.offset.y = e.offset.y)));
  }
}
class U7 {
  constructor() {
    ((this.close = !0),
      (this.fill = !0),
      (this.options = {}),
      (this.type = "circle"));
  }
  load(e) {
    if ($(e)) return;
    const r = e.options;
    if (r !== void 0)
      for (const o in r) {
        const l = r[o];
        l && (this.options[o] = je(this.options[o] ?? {}, l));
      }
    (e.close !== void 0 && (this.close = e.close),
      e.fill !== void 0 && (this.fill = e.fill),
      e.type !== void 0 && (this.type = e.type));
  }
}
class H7 extends C3 {
  constructor() {
    (super(), (this.destroy = pi.none), (this.speed = 5));
  }
  load(e) {
    (super.load(e),
      !$(e) && e.destroy !== void 0 && (this.destroy = e.destroy));
  }
}
class V7 extends z1 {
  constructor() {
    (super(), (this.animation = new H7()), (this.value = 3));
  }
  load(e) {
    if ((super.load(e), $(e))) return;
    const r = e.animation;
    r !== void 0 && this.animation.load(r);
  }
}
class fh {
  constructor() {
    this.width = 0;
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Wr.create(this.color, e.color)),
      e.width !== void 0 && (this.width = ee(e.width)),
      e.opacity !== void 0 && (this.opacity = ee(e.opacity)));
  }
}
class W7 extends hn {
  constructor() {
    (super(),
      (this.opacityRate = 1),
      (this.sizeRate = 1),
      (this.velocityRate = 1));
  }
  load(e) {
    (super.load(e),
      !$(e) &&
        (e.opacityRate !== void 0 && (this.opacityRate = e.opacityRate),
        e.sizeRate !== void 0 && (this.sizeRate = e.sizeRate),
        e.velocityRate !== void 0 && (this.velocityRate = e.velocityRate)));
  }
}
class q7 {
  constructor(e, r) {
    ((this._engine = e),
      (this._container = r),
      (this.bounce = new O1()),
      (this.collisions = new k7()),
      (this.color = new Wr()),
      (this.color.value = "#fff"),
      (this.effect = new S7()),
      (this.groups = {}),
      (this.move = new L7()),
      (this.number = new j7()),
      (this.opacity = new A7()),
      (this.reduceDuplicates = !1),
      (this.shadow = new B7()),
      (this.shape = new U7()),
      (this.size = new V7()),
      (this.stroke = new fh()),
      (this.zIndex = new W7()));
  }
  load(e) {
    if ($(e)) return;
    if (e.groups !== void 0)
      for (const o of Object.keys(e.groups)) {
        if (!Object.hasOwn(e.groups, o)) continue;
        const l = e.groups[o];
        l !== void 0 && (this.groups[o] = je(this.groups[o] ?? {}, l));
      }
    (e.reduceDuplicates !== void 0 &&
      (this.reduceDuplicates = e.reduceDuplicates),
      this.bounce.load(e.bounce),
      this.color.load(Wr.create(this.color, e.color)),
      this.effect.load(e.effect),
      this.move.load(e.move),
      this.number.load(e.number),
      this.opacity.load(e.opacity),
      this.shape.load(e.shape),
      this.size.load(e.size),
      this.shadow.load(e.shadow),
      this.zIndex.load(e.zIndex),
      this.collisions.load(e.collisions),
      e.interactivity !== void 0 &&
        (this.interactivity = je({}, e.interactivity)));
    const r = e.stroke;
    if (
      (r &&
        (this.stroke = Ke(r, (o) => {
          const l = new fh();
          return (l.load(o), l);
        })),
      this._container)
    ) {
      const o = this._engine.updaters.get(this._container);
      if (o) for (const u of o) u.loadOptions && u.loadOptions(this, e);
      const l = this._engine.interactors.get(this._container);
      if (l)
        for (const u of l)
          u.loadParticlesOptions && u.loadParticlesOptions(this, e);
    }
  }
}
function M1(n, ...e) {
  for (const r of e) n.load(r);
}
function w3(n, e, ...r) {
  const o = new q7(n, e);
  return (M1(o, ...r), o);
}
let G7 = class {
  constructor(e, r) {
    ((this._findDefaultTheme = (o) =>
      this.themes.find((l) => l.default.value && l.default.mode === o) ??
      this.themes.find((l) => l.default.value && l.default.mode === ai.any)),
      (this._importPreset = (o) => {
        this.load(this._engine.getPreset(o));
      }),
      (this._engine = e),
      (this._container = r),
      (this.autoPlay = !0),
      (this.background = new s7()),
      (this.backgroundMask = new a7()),
      (this.clear = !0),
      (this.defaultThemes = {}),
      (this.delay = 0),
      (this.fullScreen = new u7()),
      (this.detectRetina = !0),
      (this.duration = 0),
      (this.fpsLimit = 120),
      (this.interactivity = new P1(e, r)),
      (this.manualParticles = []),
      (this.particles = w3(this._engine, this._container)),
      (this.pauseOnBlur = !0),
      (this.pauseOnOutsideViewport = !0),
      (this.responsive = []),
      (this.smooth = !1),
      (this.style = {}),
      (this.themes = []),
      (this.zLayers = 100));
  }
  load(e) {
    var c, d;
    if ($(e)) return;
    (e.preset !== void 0 && Ke(e.preset, (p) => this._importPreset(p)),
      e.autoPlay !== void 0 && (this.autoPlay = e.autoPlay),
      e.clear !== void 0 && (this.clear = e.clear),
      e.key !== void 0 && (this.key = e.key),
      e.name !== void 0 && (this.name = e.name),
      e.delay !== void 0 && (this.delay = ee(e.delay)));
    const r = e.detectRetina;
    (r !== void 0 && (this.detectRetina = r),
      e.duration !== void 0 && (this.duration = ee(e.duration)));
    const o = e.fpsLimit;
    (o !== void 0 && (this.fpsLimit = o),
      e.pauseOnBlur !== void 0 && (this.pauseOnBlur = e.pauseOnBlur),
      e.pauseOnOutsideViewport !== void 0 &&
        (this.pauseOnOutsideViewport = e.pauseOnOutsideViewport),
      e.zLayers !== void 0 && (this.zLayers = e.zLayers),
      this.background.load(e.background));
    const l = e.fullScreen;
    (a1(l) ? (this.fullScreen.enable = l) : this.fullScreen.load(l),
      this.backgroundMask.load(e.backgroundMask),
      this.interactivity.load(e.interactivity),
      e.manualParticles &&
        (this.manualParticles = e.manualParticles.map((p) => {
          const m = new y7();
          return (m.load(p), m);
        })),
      this.particles.load(e.particles),
      (this.style = je(this.style, e.style)),
      this._engine.loadOptions(this, e),
      e.smooth !== void 0 && (this.smooth = e.smooth));
    const u = this._engine.interactors.get(this._container);
    if (u) for (const p of u) p.loadOptions && p.loadOptions(this, e);
    if (e.responsive !== void 0)
      for (const p of e.responsive) {
        const m = new g7();
        (m.load(p), this.responsive.push(m));
      }
    if (
      (this.responsive.sort((p, m) => p.maxWidth - m.maxWidth),
      e.themes !== void 0)
    )
      for (const p of e.themes) {
        const m = this.themes.find((g) => g.name === p.name);
        if (m) m.load(p);
        else {
          const g = new C7();
          (g.load(p), this.themes.push(g));
        }
      }
    ((this.defaultThemes.dark =
      (c = this._findDefaultTheme(ai.dark)) == null ? void 0 : c.name),
      (this.defaultThemes.light =
        (d = this._findDefaultTheme(ai.light)) == null ? void 0 : d.name));
  }
  setResponsive(e, r, o) {
    this.load(o);
    const l = this.responsive.find((u) =>
      u.mode === Ni.screen && screen
        ? u.maxWidth > screen.availWidth
        : u.maxWidth * r > e,
    );
    return (
      this.load(l == null ? void 0 : l.options),
      l == null ? void 0 : l.maxWidth
    );
  }
  setTheme(e) {
    if (e) {
      const r = this.themes.find((o) => o.name === e);
      r && this.load(r.options);
    } else {
      const r = h1("(prefers-color-scheme: dark)"),
        o = r == null ? void 0 : r.matches,
        l = this._findDefaultTheme(o ? ai.dark : ai.light);
      l && this.load(l.options);
    }
  }
};
var qr;
(function (n) {
  ((n.external = "external"), (n.particles = "particles"));
})(qr || (qr = {}));
class Q7 {
  constructor(e, r) {
    ((this.container = r),
      (this._engine = e),
      (this._interactors = []),
      (this._externalInteractors = []),
      (this._particleInteractors = []));
  }
  externalInteract(e) {
    for (const r of this._externalInteractors) r.isEnabled() && r.interact(e);
  }
  handleClickMode(e) {
    var r;
    for (const o of this._externalInteractors)
      (r = o.handleClickMode) == null || r.call(o, e);
  }
  async init() {
    ((this._interactors = await this._engine.getInteractors(
      this.container,
      !0,
    )),
      (this._externalInteractors = []),
      (this._particleInteractors = []));
    for (const e of this._interactors) {
      switch (e.type) {
        case qr.external:
          this._externalInteractors.push(e);
          break;
        case qr.particles:
          this._particleInteractors.push(e);
          break;
      }
      e.init();
    }
  }
  particlesInteract(e, r) {
    for (const o of this._externalInteractors) o.clear(e, r);
    for (const o of this._particleInteractors)
      o.isEnabled(e) && o.interact(e, r);
  }
  reset(e) {
    for (const r of this._externalInteractors) r.isEnabled() && r.reset(e);
    for (const r of this._particleInteractors) r.isEnabled(e) && r.reset(e);
  }
}
var fn;
(function (n) {
  ((n.normal = "normal"), (n.inside = "inside"), (n.outside = "outside"));
})(fn || (fn = {}));
const dh = 0,
  e3 = 2,
  pl = 0.5,
  Z7 = 2,
  hh = "random";
function K7(n, e, r, o) {
  const l = e.options[n];
  if (l) return je({ close: e.close, fill: e.fill }, ct(l, r, o));
}
function Y7(n, e, r, o) {
  const l = e.options[n];
  if (l) return je({ close: e.close, fill: e.fill }, ct(l, r, o));
}
function ph(n) {
  if (!Oe(n.outMode, n.checkModes)) return;
  const e = n.radius * e3;
  n.coord > n.maxCoord - e
    ? n.setCb(-n.radius)
    : n.coord < e && n.setCb(n.radius);
}
class X7 {
  constructor(e, r) {
    ((this.container = r),
      (this._calcPosition = (o, l, u, c = dh) => {
        for (const b of o.plugins.values()) {
          const _ =
            b.particlePosition !== void 0
              ? b.particlePosition(l, this)
              : void 0;
          if (_) return At.create(_.x, _.y, u);
        }
        const d = o.canvas.size,
          p = Lp({ size: d, position: l }),
          m = At.create(p.x, p.y, u),
          g = this.getRadius(),
          v = this.options.move.outModes,
          C = (b) => {
            ph({
              outMode: b,
              checkModes: [Ze.bounce],
              coord: m.x,
              maxCoord: o.canvas.size.width,
              setCb: (_) => (m.x += _),
              radius: g,
            });
          },
          x = (b) => {
            ph({
              outMode: b,
              checkModes: [Ze.bounce],
              coord: m.y,
              maxCoord: o.canvas.size.height,
              setCb: (_) => (m.y += _),
              radius: g,
            });
          };
        return (
          C(v.left ?? v.default),
          C(v.right ?? v.default),
          x(v.top ?? v.default),
          x(v.bottom ?? v.default),
          this._checkOverlap(m, c) ? this._calcPosition(o, void 0, u, c + 1) : m
        );
      }),
      (this._calculateVelocity = () => {
        const o = Ip(this.direction),
          l = o.copy(),
          u = this.options.move;
        if (u.direction === lt.inside || u.direction === lt.outside) return l;
        const c = $n(H(u.angle.value)),
          d = $n(H(u.angle.offset)),
          p = { left: d - c * pl, right: d + c * pl };
        return (
          u.straight || (l.angle += ut(ee(p.left, p.right))),
          u.random && typeof u.speed == "number" && (l.length *= se()),
          l
        );
      }),
      (this._checkOverlap = (o, l = dh) => {
        const u = this.options.collisions,
          c = this.getRadius();
        if (!u.enable) return !1;
        const d = u.overlap;
        if (d.enable) return !1;
        const p = d.retries;
        if (p >= 0 && l > p)
          throw new Error(`${Kt} particle is overlapping and can't be placed`);
        return !!this.container.particles.find(
          (g) => kt(o, g.position) < c + g.getRadius(),
        );
      }),
      (this._getRollColor = (o) => {
        if (!o || !this.roll || (!this.backColor && !this.roll.alter)) return o;
        const l = 1,
          u = 0,
          c = this.roll.horizontal && this.roll.vertical ? e3 * l : l,
          d = this.roll.horizontal ? Math.PI * pl : u;
        return Math.floor(((this.roll.angle ?? u) + d) / (Math.PI / c)) % e3
          ? this.backColor
            ? this.backColor
            : this.roll.alter
              ? n7(o, this.roll.alter.type, this.roll.alter.value)
              : o
          : o;
      }),
      (this._initPosition = (o) => {
        const l = this.container,
          u = H(this.options.zIndex.value),
          c = 0;
        ((this.position = this._calcPosition(l, o, Yt(u, c, l.zLayers))),
          (this.initialPosition = this.position.copy()));
        const d = l.canvas.size,
          p = 0;
        switch (
          ((this.moveCenter = {
            ...w1(this.options.move.center, d),
            radius: this.options.move.center.radius ?? p,
            mode: this.options.move.center.mode ?? En.percent,
          }),
          (this.direction = Tp(
            this.options.move.direction,
            this.position,
            this.moveCenter,
          )),
          this.options.move.direction)
        ) {
          case lt.inside:
            this.outType = fn.inside;
            break;
          case lt.outside:
            this.outType = fn.outside;
            break;
        }
        this.offset = ze.origin;
      }),
      (this._engine = e));
  }
  destroy(e) {
    var u, c, d;
    if (this.unbreakable || this.destroyed) return;
    ((this.destroyed = !0),
      (this.bubble.inRange = !1),
      (this.slow.inRange = !1));
    const r = this.container,
      o = this.pathGenerator,
      l = r.shapeDrawers.get(this.shape);
    (u = l == null ? void 0 : l.particleDestroy) == null || u.call(l, this);
    for (const p of r.plugins.values())
      (c = p.particleDestroyed) == null || c.call(p, this, e);
    for (const p of r.particles.updaters)
      (d = p.particleDestroyed) == null || d.call(p, this, e);
    (o == null || o.reset(this),
      this._engine.dispatchEvent(bt.particleDestroyed, {
        container: this.container,
        data: { particle: this },
      }));
  }
  draw(e) {
    const r = this.container,
      o = r.canvas;
    for (const l of r.plugins.values()) o.drawParticlePlugin(l, this, e);
    o.drawParticle(this, e);
  }
  getFillColor() {
    return this._getRollColor(this.bubble.color ?? oh(this.color));
  }
  getMass() {
    return this.getRadius() ** Z7 * Math.PI * pl;
  }
  getPosition() {
    return {
      x: this.position.x + this.offset.x,
      y: this.position.y + this.offset.y,
      z: this.position.z,
    };
  }
  getRadius() {
    return this.bubble.radius ?? this.size.value;
  }
  getStrokeColor() {
    return this._getRollColor(this.bubble.color ?? oh(this.strokeColor));
  }
  init(e, r, o, l) {
    var ie, he, _e, Se, We, Be;
    const u = this.container,
      c = this._engine;
    ((this.id = e),
      (this.group = l),
      (this.effectClose = !0),
      (this.effectFill = !0),
      (this.shapeClose = !0),
      (this.shapeFill = !0),
      (this.pathRotation = !1),
      (this.lastPathTime = 0),
      (this.destroyed = !1),
      (this.unbreakable = !1),
      (this.isRotating = !1),
      (this.rotation = 0),
      (this.misplaced = !1),
      (this.retina = { maxDistance: {} }),
      (this.outType = fn.normal),
      (this.ignoresResizeRatio = !0));
    const d = u.retina.pixelRatio,
      p = u.actualOptions,
      m = w3(this._engine, u, p.particles),
      { reduceDuplicates: g } = m,
      v = m.effect.type,
      C = m.shape.type;
    ((this.effect = ct(v, this.id, g)), (this.shape = ct(C, this.id, g)));
    const x = m.effect,
      b = m.shape;
    if (o) {
      if ((ie = o.effect) != null && ie.type) {
        const pe = o.effect.type,
          qe = ct(pe, this.id, g);
        qe && ((this.effect = qe), x.load(o.effect));
      }
      if ((he = o.shape) != null && he.type) {
        const pe = o.shape.type,
          qe = ct(pe, this.id, g);
        qe && ((this.shape = qe), b.load(o.shape));
      }
    }
    if (this.effect === hh) {
      const pe = [...this.container.effectDrawers.keys()];
      this.effect = pe[Math.floor(Math.random() * pe.length)];
    }
    if (this.shape === hh) {
      const pe = [...this.container.shapeDrawers.keys()];
      this.shape = pe[Math.floor(Math.random() * pe.length)];
    }
    ((this.effectData = K7(this.effect, x, this.id, g)),
      (this.shapeData = Y7(this.shape, b, this.id, g)),
      m.load(o));
    const _ = this.effectData;
    _ && m.load(_.particles);
    const E = this.shapeData;
    E && m.load(E.particles);
    const T = new P1(c, u);
    (T.load(u.actualOptions.interactivity),
      T.load(m.interactivity),
      (this.interactivity = T),
      (this.effectFill = (_ == null ? void 0 : _.fill) ?? m.effect.fill),
      (this.effectClose = (_ == null ? void 0 : _.close) ?? m.effect.close),
      (this.shapeFill = (E == null ? void 0 : E.fill) ?? m.shape.fill),
      (this.shapeClose = (E == null ? void 0 : E.close) ?? m.shape.close),
      (this.options = m));
    const D = this.options.move.path;
    ((this.pathDelay = H(D.delay.value) * Fe),
      D.generator &&
        ((this.pathGenerator = this._engine.getPathGenerator(D.generator)),
        this.pathGenerator &&
          u.addPath(D.generator, this.pathGenerator) &&
          this.pathGenerator.init(u)),
      u.retina.initParticle(this),
      (this.size = v1(this.options.size, d)),
      (this.bubble = { inRange: !1 }),
      (this.slow = { inRange: !1, factor: 1 }),
      this._initPosition(r),
      (this.initialVelocity = this._calculateVelocity()),
      (this.velocity = this.initialVelocity.copy()));
    const I = 1;
    this.moveDecay = I - H(this.options.move.decay);
    const R = u.particles;
    (R.setLastZIndex(this.position.z),
      (this.zIndexFactor = this.position.z / u.zLayers),
      (this.sides = 24));
    let N = u.effectDrawers.get(this.effect);
    (N ||
      ((N = this._engine.getEffectDrawer(this.effect)),
      N && u.effectDrawers.set(this.effect, N)),
      N != null && N.loadEffect && N.loadEffect(this));
    let F = u.shapeDrawers.get(this.shape);
    (F ||
      ((F = this._engine.getShapeDrawer(this.shape)),
      F && u.shapeDrawers.set(this.shape, F)),
      F != null && F.loadShape && F.loadShape(this));
    const V = F == null ? void 0 : F.getSidesCount;
    (V && (this.sides = V(this)),
      (this.spawning = !1),
      (this.shadowColor = Qt(this._engine, this.options.shadow.color)));
    for (const pe of R.updaters) pe.init(this);
    for (const pe of R.movers) (_e = pe.init) == null || _e.call(pe, this);
    ((Se = N == null ? void 0 : N.particleInit) == null || Se.call(N, u, this),
      (We = F == null ? void 0 : F.particleInit) == null ||
        We.call(F, u, this));
    for (const pe of u.plugins.values())
      (Be = pe.particleCreated) == null || Be.call(pe, this);
  }
  isInsideCanvas() {
    const e = this.getRadius(),
      r = this.container.canvas.size,
      o = this.position;
    return o.x >= -e && o.y >= -e && o.y <= r.height + e && o.x <= r.width + e;
  }
  isVisible() {
    return !this.destroyed && !this.spawning && this.isInsideCanvas();
  }
  reset() {
    var e;
    for (const r of this.container.particles.updaters)
      (e = r.reset) == null || e.call(r, this);
  }
}
class J7 {
  constructor(e, r) {
    ((this.position = e), (this.particle = r));
  }
}
var Tr;
(function (n) {
  ((n.circle = "circle"), (n.rectangle = "rectangle"));
})(Tr || (Tr = {}));
const Fo = 2;
class R1 {
  constructor(e, r, o) {
    ((this.position = { x: e, y: r }), (this.type = o));
  }
}
class wt extends R1 {
  constructor(e, r, o) {
    (super(e, r, Tr.circle), (this.radius = o));
  }
  contains(e) {
    return kt(e, this.position) <= this.radius;
  }
  intersects(e) {
    const r = this.position,
      o = e.position,
      l = { x: Math.abs(o.x - r.x), y: Math.abs(o.y - r.y) },
      u = this.radius;
    if (e instanceof wt || e.type === Tr.circle) {
      const c = e,
        d = u + c.radius,
        p = Math.sqrt(l.x ** Fo + l.y ** Fo);
      return d > p;
    } else if (e instanceof dn || e.type === Tr.rectangle) {
      const c = e,
        { width: d, height: p } = c.size;
      return (
        Math.pow(l.x - d, Fo) + Math.pow(l.y - p, Fo) <= u ** Fo ||
        (l.x <= u + d && l.y <= u + p) ||
        l.x <= d ||
        l.y <= p
      );
    }
    return !1;
  }
}
class dn extends R1 {
  constructor(e, r, o, l) {
    (super(e, r, Tr.rectangle), (this.size = { height: l, width: o }));
  }
  contains(e) {
    const r = this.size.width,
      o = this.size.height,
      l = this.position;
    return e.x >= l.x && e.x <= l.x + r && e.y >= l.y && e.y <= l.y + o;
  }
  intersects(e) {
    if (e instanceof wt) return e.intersects(this);
    const r = this.size.width,
      o = this.size.height,
      l = this.position,
      u = e.position,
      c = e instanceof dn ? e.size : { width: 0, height: 0 },
      d = c.width,
      p = c.height;
    return u.x < l.x + r && u.x + d > l.x && u.y < l.y + o && u.y + p > l.y;
  }
}
const Ao = 0.5,
  e8 = 2,
  t8 = 4;
class Hl {
  constructor(e, r) {
    ((this.rectangle = e),
      (this.capacity = r),
      (this._subdivide = () => {
        const { x: o, y: l } = this.rectangle.position,
          { width: u, height: c } = this.rectangle.size,
          { capacity: d } = this;
        for (let p = 0; p < t8; p++) {
          const m = p % e8;
          this._subs.push(
            new Hl(
              new dn(
                o + u * Ao * m,
                l + c * Ao * (Math.round(p * Ao) - m),
                u * Ao,
                c * Ao,
              ),
              d,
            ),
          );
        }
        this._divided = !0;
      }),
      (this._points = []),
      (this._divided = !1),
      (this._subs = []));
  }
  insert(e) {
    return this.rectangle.contains(e.position)
      ? this._points.length < this.capacity
        ? (this._points.push(e), !0)
        : (this._divided || this._subdivide(),
          this._subs.some((r) => r.insert(e)))
      : !1;
  }
  query(e, r) {
    const o = [];
    if (!e.intersects(this.rectangle)) return [];
    for (const l of this._points)
      (!e.contains(l.position) &&
        kt(e.position, l.position) > l.particle.getRadius() &&
        (!r || r(l.particle))) ||
        o.push(l.particle);
    if (this._divided) for (const l of this._subs) o.push(...l.query(e, r));
    return o;
  }
  queryCircle(e, r, o) {
    return this.query(new wt(e.x, e.y, r), o);
  }
  queryRectangle(e, r, o) {
    return this.query(new dn(e.x, e.y, r.width, r.height), o);
  }
}
const mh = 4,
  n8 = 2,
  i8 = 1,
  yh = (n) => {
    const { height: e, width: r } = n,
      o = -0.25,
      l = 1.5;
    return new dn(o * r, o * e, l * r, l * e);
  };
class r8 {
  constructor(e, r) {
    ((this._addToPool = (...l) => {
      this._pool.push(...l);
    }),
      (this._applyDensity = (l, u, c) => {
        var b;
        const d = l.number;
        if (!((b = l.number.density) != null && b.enable)) {
          c === void 0
            ? (this._limit = d.limit.value)
            : d.limit && this._groupLimits.set(c, d.limit.value);
          return;
        }
        const p = this._initDensityFactor(d.density),
          m = d.value,
          g = 0,
          v = d.limit.value > g ? d.limit.value : m,
          C = Math.min(m, v) * p + u,
          x = Math.min(this.count, this.filter((_) => _.group === c).length);
        (c === void 0
          ? (this._limit = d.limit.value * p)
          : this._groupLimits.set(c, d.limit.value * p),
          x < C
            ? this.push(Math.abs(C - x), void 0, l, c)
            : x > C && this.removeQuantity(x - C, c));
      }),
      (this._initDensityFactor = (l) => {
        const u = this._container,
          c = 1;
        if (!u.canvas.element || !l.enable) return c;
        const d = u.canvas.element,
          p = u.retina.pixelRatio;
        return (d.width * d.height) / (l.height * l.width * p ** n8);
      }),
      (this._pushParticle = (l, u, c, d) => {
        try {
          let p = this._pool.pop();
          (p || (p = new X7(this._engine, this._container)),
            p.init(this._nextId, l, u, c));
          let m = !0;
          return (
            d && (m = d(p)),
            m
              ? (this._array.push(p),
                this._zArray.push(p),
                this._nextId++,
                this._engine.dispatchEvent(bt.particleAdded, {
                  container: this._container,
                  data: { particle: p },
                }),
                p)
              : void 0
          );
        } catch (p) {
          Gi().warning(`${Kt} adding particle: ${p}`);
        }
      }),
      (this._removeParticle = (l, u, c) => {
        const d = this._array[l];
        if (!d || d.group !== u) return !1;
        const p = this._zArray.indexOf(d),
          m = 1;
        return (
          this._array.splice(l, m),
          this._zArray.splice(p, m),
          d.destroy(c),
          this._engine.dispatchEvent(bt.particleRemoved, {
            container: this._container,
            data: { particle: d },
          }),
          this._addToPool(d),
          !0
        );
      }),
      (this._engine = e),
      (this._container = r),
      (this._nextId = 0),
      (this._array = []),
      (this._zArray = []),
      (this._pool = []),
      (this._limit = 0),
      (this._groupLimits = new Map()),
      (this._needsSort = !1),
      (this._lastZIndex = 0),
      (this._interactionManager = new Q7(e, r)),
      (this._pluginsInitialized = !1));
    const o = r.canvas.size;
    ((this.quadTree = new Hl(yh(o), mh)),
      (this.movers = []),
      (this.updaters = []));
  }
  get count() {
    return this._array.length;
  }
  addManualParticles() {
    const e = this._container;
    e.actualOptions.manualParticles.forEach((o) =>
      this.addParticle(
        o.position ? w1(o.position, e.canvas.size) : void 0,
        o.options,
      ),
    );
  }
  addParticle(e, r, o, l) {
    const u = this._container.actualOptions.particles.number.limit.mode,
      c =
        o === void 0 ? this._limit : (this._groupLimits.get(o) ?? this._limit),
      d = this.count;
    if (c > 0)
      switch (u) {
        case Zo.delete: {
          const v = d + 1 - c;
          v > 0 && this.removeQuantity(v);
          break;
        }
        case Zo.wait:
          if (d >= c) return;
          break;
      }
    return this._pushParticle(e, r, o, l);
  }
  clear() {
    ((this._array = []), (this._zArray = []), (this._pluginsInitialized = !1));
  }
  destroy() {
    ((this._array = []),
      (this._zArray = []),
      (this.movers = []),
      (this.updaters = []));
  }
  draw(e) {
    const r = this._container,
      o = r.canvas;
    (o.clear(), this.update(e));
    for (const l of r.plugins.values()) o.drawPlugin(l, e);
    for (const l of this._zArray) l.draw(e);
  }
  filter(e) {
    return this._array.filter(e);
  }
  find(e) {
    return this._array.find(e);
  }
  get(e) {
    return this._array[e];
  }
  handleClickMode(e) {
    this._interactionManager.handleClickMode(e);
  }
  async init() {
    var l, u;
    const e = this._container,
      r = e.actualOptions;
    ((this._lastZIndex = 0), (this._needsSort = !1), await this.initPlugins());
    let o = !1;
    for (const c of e.plugins.values())
      if (
        ((o =
          ((l = c.particlesInitialization) == null ? void 0 : l.call(c)) ?? o),
        o)
      )
        break;
    if ((this.addManualParticles(), !o)) {
      const c = r.particles,
        d = c.groups;
      for (const p in d) {
        const m = d[p];
        for (
          let g = this.count, v = 0;
          v < ((u = m.number) == null ? void 0 : u.value) && g < c.number.value;
          g++, v++
        )
          this.addParticle(void 0, m, p);
      }
      for (let p = this.count; p < c.number.value; p++) this.addParticle();
    }
  }
  async initPlugins() {
    if (this._pluginsInitialized) return;
    const e = this._container;
    ((this.movers = await this._engine.getMovers(e, !0)),
      (this.updaters = await this._engine.getUpdaters(e, !0)),
      await this._interactionManager.init());
    for (const r of e.pathGenerators.values()) r.init(e);
  }
  push(e, r, o, l) {
    for (let u = 0; u < e; u++)
      this.addParticle(r == null ? void 0 : r.position, o, l);
  }
  async redraw() {
    (this.clear(), await this.init(), this.draw({ value: 0, factor: 0 }));
  }
  remove(e, r, o) {
    this.removeAt(this._array.indexOf(e), void 0, r, o);
  }
  removeAt(e, r = i8, o, l) {
    if (e < 0 || e > this.count) return;
    let c = 0;
    for (let d = e; c < r && d < this.count; d++)
      this._removeParticle(d, o, l) && (d--, c++);
  }
  removeQuantity(e, r) {
    this.removeAt(0, e, r);
  }
  setDensity() {
    const e = this._container.actualOptions,
      r = e.particles.groups,
      o = 0;
    for (const l in r) this._applyDensity(r[l], o, l);
    this._applyDensity(e.particles, e.manualParticles.length);
  }
  setLastZIndex(e) {
    ((this._lastZIndex = e),
      (this._needsSort = this._needsSort || this._lastZIndex < e));
  }
  setResizeFactor(e) {
    this._resizeFactor = e;
  }
  update(e) {
    var u, c;
    const r = this._container,
      o = new Set();
    this.quadTree = new Hl(yh(r.canvas.size), mh);
    for (const d of r.pathGenerators.values()) d.update();
    for (const d of r.plugins.values()) (u = d.update) == null || u.call(d, e);
    const l = this._resizeFactor;
    for (const d of this._array) {
      (l &&
        !d.ignoresResizeRatio &&
        ((d.position.x *= l.width),
        (d.position.y *= l.height),
        (d.initialPosition.x *= l.width),
        (d.initialPosition.y *= l.height)),
        (d.ignoresResizeRatio = !1),
        this._interactionManager.reset(d));
      for (const p of this._container.plugins.values()) {
        if (d.destroyed) break;
        (c = p.particleUpdate) == null || c.call(p, d, e);
      }
      for (const p of this.movers) p.isEnabled(d) && p.move(d, e);
      if (d.destroyed) {
        o.add(d);
        continue;
      }
      this.quadTree.insert(new J7(d.getPosition(), d));
    }
    if (o.size) {
      const d = (p) => !o.has(p);
      ((this._array = this.filter(d)), (this._zArray = this._zArray.filter(d)));
      for (const p of o)
        this._engine.dispatchEvent(bt.particleRemoved, {
          container: this._container,
          data: { particle: p },
        });
      this._addToPool(...o);
    }
    this._interactionManager.externalInteract(e);
    for (const d of this._array) {
      for (const p of this.updaters) p.update(d, e);
      !d.destroyed &&
        !d.spawning &&
        this._interactionManager.particlesInteract(d, e);
    }
    if ((delete this._resizeFactor, this._needsSort)) {
      const d = this._zArray;
      d.sort((m, g) => g.position.z - m.position.z || m.id - g.id);
      const p = 1;
      ((this._lastZIndex = d[d.length - p].position.z), (this._needsSort = !1));
    }
  }
}
const gh = 1,
  vh = 1;
class o8 {
  constructor(e) {
    ((this.container = e), (this.pixelRatio = gh), (this.reduceFactor = vh));
  }
  init() {
    const e = this.container,
      r = e.actualOptions;
    ((this.pixelRatio = !r.detectRetina || Qi() ? gh : window.devicePixelRatio),
      (this.reduceFactor = vh));
    const o = this.pixelRatio,
      l = e.canvas;
    if (l.element) {
      const d = l.element;
      ((l.size.width = d.offsetWidth * o),
        (l.size.height = d.offsetHeight * o));
    }
    const u = r.particles,
      c = u.move;
    ((this.maxSpeed = H(c.gravity.maxSpeed) * o),
      (this.sizeAnimationSpeed = H(u.size.animation.speed) * o));
  }
  initParticle(e) {
    const r = e.options,
      o = this.pixelRatio,
      l = r.move,
      u = l.distance,
      c = e.retina;
    ((c.moveDrift = H(l.drift) * o),
      (c.moveSpeed = H(l.speed) * o),
      (c.sizeAnimationSpeed = H(r.size.animation.speed) * o));
    const d = c.maxDistance;
    ((d.horizontal = u.horizontal !== void 0 ? u.horizontal * o : void 0),
      (d.vertical = u.vertical !== void 0 ? u.vertical * o : void 0),
      (c.maxSpeed = H(l.gravity.maxSpeed) * o));
  }
}
function Ne(n) {
  return n && !n.destroyed;
}
const bc = 60;
function s8(n, e = bc, r = !1) {
  return { value: n, factor: r ? bc / e : (bc * n) / Fe };
}
function xr(n, e, ...r) {
  const o = new G7(n, e);
  return (M1(o, ...r), o);
}
let l8 = class {
  constructor(e, r, o) {
    ((this._intersectionManager = (l) => {
      if (!(!Ne(this) || !this.actualOptions.pauseOnOutsideViewport))
        for (const u of l)
          u.target === this.interactivity.element &&
            (u.isIntersecting ? this.play() : this.pause());
    }),
      (this._nextFrame = (l) => {
        try {
          if (
            !this._smooth &&
            this._lastFrameTime !== void 0 &&
            l < this._lastFrameTime + Fe / this.fpsLimit
          ) {
            this.draw(!1);
            return;
          }
          this._lastFrameTime ?? (this._lastFrameTime = l);
          const u = s8(l - this._lastFrameTime, this.fpsLimit, this._smooth);
          if (
            (this.addLifeTime(u.value), (this._lastFrameTime = l), u.value > Fe)
          ) {
            this.draw(!1);
            return;
          }
          if ((this.particles.draw(u), !this.alive())) {
            this.destroy();
            return;
          }
          this.animationStatus && this.draw(!1);
        } catch (u) {
          Gi().error(`${Kt} in animation loop`, u);
        }
      }),
      (this._engine = e),
      (this.id = Symbol(r)),
      (this.fpsLimit = 120),
      (this._smooth = !1),
      (this._delay = 0),
      (this._duration = 0),
      (this._lifeTime = 0),
      (this._firstStart = !0),
      (this.started = !1),
      (this.destroyed = !1),
      (this._paused = !0),
      (this._lastFrameTime = 0),
      (this.zLayers = 100),
      (this.pageHidden = !1),
      (this._clickHandlers = new Map()),
      (this._sourceOptions = o),
      (this._initialSourceOptions = o),
      (this.retina = new o8(this)),
      (this.canvas = new r7(this, this._engine)),
      (this.particles = new r8(this._engine, this)),
      (this.pathGenerators = new Map()),
      (this.interactivity = { mouse: { clicking: !1, inside: !1 } }),
      (this.plugins = new Map()),
      (this.effectDrawers = new Map()),
      (this.shapeDrawers = new Map()),
      (this._options = xr(this._engine, this)),
      (this.actualOptions = xr(this._engine, this)),
      (this._eventListeners = new o7(this)),
      (this._intersectionObserver = $p((l) => this._intersectionManager(l))),
      this._engine.dispatchEvent(bt.containerBuilt, { container: this }));
  }
  get animationStatus() {
    return !this._paused && !this.pageHidden && Ne(this);
  }
  get options() {
    return this._options;
  }
  get sourceOptions() {
    return this._sourceOptions;
  }
  addClickHandler(e) {
    if (!Ne(this)) return;
    const r = this.interactivity.element;
    if (!r) return;
    const o = (v, C, x) => {
        if (!Ne(this)) return;
        const b = this.retina.pixelRatio,
          _ = { x: C.x * b, y: C.y * b },
          E = this.particles.quadTree.queryCircle(_, x * b);
        e(v, E);
      },
      l = (v) => {
        if (!Ne(this)) return;
        const C = v,
          x = { x: C.offsetX || C.clientX, y: C.offsetY || C.clientY };
        o(v, x, 1);
      },
      u = () => {
        Ne(this) && ((m = !0), (g = !1));
      },
      c = () => {
        Ne(this) && (g = !0);
      },
      d = (v) => {
        if (Ne(this)) {
          if (m && !g) {
            const C = v,
              x = 1;
            let b = C.touches[C.touches.length - x];
            if (!b && ((b = C.changedTouches[C.changedTouches.length - x]), !b))
              return;
            const _ = this.canvas.element,
              E = _ ? _.getBoundingClientRect() : void 0,
              T = 0,
              D = {
                x: b.clientX - (E ? E.left : T),
                y: b.clientY - (E ? E.top : T),
              };
            o(v, D, Math.max(b.radiusX, b.radiusY));
          }
          ((m = !1), (g = !1));
        }
      },
      p = () => {
        Ne(this) && ((m = !1), (g = !1));
      };
    let m = !1,
      g = !1;
    (this._clickHandlers.set("click", l),
      this._clickHandlers.set("touchstart", u),
      this._clickHandlers.set("touchmove", c),
      this._clickHandlers.set("touchend", d),
      this._clickHandlers.set("touchcancel", p));
    for (const [v, C] of this._clickHandlers) r.addEventListener(v, C);
  }
  addLifeTime(e) {
    this._lifeTime += e;
  }
  addPath(e, r, o = !1) {
    return !Ne(this) || (!o && this.pathGenerators.has(e))
      ? !1
      : (this.pathGenerators.set(e, r), !0);
  }
  alive() {
    return !this._duration || this._lifeTime <= this._duration;
  }
  clearClickHandlers() {
    var e;
    if (Ne(this)) {
      for (const [r, o] of this._clickHandlers)
        (e = this.interactivity.element) == null || e.removeEventListener(r, o);
      this._clickHandlers.clear();
    }
  }
  destroy(e = !0) {
    var r, o;
    if (Ne(this)) {
      (this.stop(),
        this.clearClickHandlers(),
        this.particles.destroy(),
        this.canvas.destroy());
      for (const l of this.effectDrawers.values())
        (r = l.destroy) == null || r.call(l, this);
      for (const l of this.shapeDrawers.values())
        (o = l.destroy) == null || o.call(l, this);
      for (const l of this.effectDrawers.keys()) this.effectDrawers.delete(l);
      for (const l of this.shapeDrawers.keys()) this.shapeDrawers.delete(l);
      if ((this._engine.clearPlugins(this), (this.destroyed = !0), e)) {
        const l = this._engine.items,
          u = l.findIndex((d) => d === this);
        u >= 0 && l.splice(u, 1);
      }
      this._engine.dispatchEvent(bt.containerDestroyed, { container: this });
    }
  }
  draw(e) {
    if (!Ne(this)) return;
    let r = e;
    const o = (l) => {
      (r && ((this._lastFrameTime = void 0), (r = !1)), this._nextFrame(l));
    };
    this._drawAnimationFrame = Rp((l) => o(l));
  }
  async export(e, r = {}) {
    for (const o of this.plugins.values()) {
      if (!o.export) continue;
      const l = await o.export(e, r);
      if (l.supported) return l.blob;
    }
    Gi().error(`${Kt} - Export plugin with type ${e} not found`);
  }
  handleClickMode(e) {
    var r;
    if (Ne(this)) {
      this.particles.handleClickMode(e);
      for (const o of this.plugins.values())
        (r = o.handleClickMode) == null || r.call(o, e);
    }
  }
  async init() {
    var v, C, x, b;
    if (!Ne(this)) return;
    const e = this._engine.getSupportedEffects();
    for (const _ of e) {
      const E = this._engine.getEffectDrawer(_);
      E && this.effectDrawers.set(_, E);
    }
    const r = this._engine.getSupportedShapes();
    for (const _ of r) {
      const E = this._engine.getShapeDrawer(_);
      E && this.shapeDrawers.set(_, E);
    }
    (await this.particles.initPlugins(),
      (this._options = xr(
        this._engine,
        this,
        this._initialSourceOptions,
        this.sourceOptions,
      )),
      (this.actualOptions = xr(this._engine, this, this._options)));
    const o = await this._engine.getAvailablePlugins(this);
    for (const [_, E] of o) this.plugins.set(_, E);
    (this.retina.init(),
      await this.canvas.init(),
      this.updateActualOptions(),
      this.canvas.initBackground(),
      this.canvas.resize());
    const {
      zLayers: l,
      duration: u,
      delay: c,
      fpsLimit: d,
      smooth: p,
    } = this.actualOptions;
    ((this.zLayers = l),
      (this._duration = H(u) * Fe),
      (this._delay = H(c) * Fe),
      (this._lifeTime = 0));
    const m = 120,
      g = 0;
    ((this.fpsLimit = d > g ? d : m), (this._smooth = p));
    for (const _ of this.effectDrawers.values())
      await ((v = _.init) == null ? void 0 : v.call(_, this));
    for (const _ of this.shapeDrawers.values())
      await ((C = _.init) == null ? void 0 : C.call(_, this));
    for (const _ of this.plugins.values())
      await ((x = _.init) == null ? void 0 : x.call(_));
    (this._engine.dispatchEvent(bt.containerInit, { container: this }),
      await this.particles.init(),
      this.particles.setDensity());
    for (const _ of this.plugins.values())
      (b = _.particlesSetup) == null || b.call(_);
    this._engine.dispatchEvent(bt.particlesSetup, { container: this });
  }
  async loadTheme(e) {
    Ne(this) && ((this._currentTheme = e), await this.refresh());
  }
  pause() {
    var e;
    if (
      Ne(this) &&
      (this._drawAnimationFrame !== void 0 &&
        (Dp(this._drawAnimationFrame), delete this._drawAnimationFrame),
      !this._paused)
    ) {
      for (const r of this.plugins.values()) (e = r.pause) == null || e.call(r);
      (this.pageHidden || (this._paused = !0),
        this._engine.dispatchEvent(bt.containerPaused, { container: this }));
    }
  }
  play(e) {
    if (!Ne(this)) return;
    const r = this._paused || e;
    if (this._firstStart && !this.actualOptions.autoPlay) {
      this._firstStart = !1;
      return;
    }
    if ((this._paused && (this._paused = !1), r))
      for (const o of this.plugins.values()) o.play && o.play();
    (this._engine.dispatchEvent(bt.containerPlay, { container: this }),
      this.draw(r ?? !1));
  }
  async refresh() {
    if (Ne(this)) return (this.stop(), this.start());
  }
  async reset(e) {
    if (Ne(this))
      return (
        (this._initialSourceOptions = e),
        (this._sourceOptions = e),
        (this._options = xr(
          this._engine,
          this,
          this._initialSourceOptions,
          this.sourceOptions,
        )),
        (this.actualOptions = xr(this._engine, this, this._options)),
        this.refresh()
      );
  }
  async start() {
    !Ne(this) ||
      this.started ||
      (await this.init(),
      (this.started = !0),
      await new Promise((e) => {
        const r = async () => {
          var o;
          (this._eventListeners.addListeners(),
            this.interactivity.element instanceof HTMLElement &&
              this._intersectionObserver &&
              this._intersectionObserver.observe(this.interactivity.element));
          for (const l of this.plugins.values())
            await ((o = l.start) == null ? void 0 : o.call(l));
          (this._engine.dispatchEvent(bt.containerStarted, { container: this }),
            this.play(),
            e());
        };
        this._delayTimeout = setTimeout(() => void r(), this._delay);
      }));
  }
  stop() {
    var e;
    if (!(!Ne(this) || !this.started)) {
      (this._delayTimeout &&
        (clearTimeout(this._delayTimeout), delete this._delayTimeout),
        (this._firstStart = !0),
        (this.started = !1),
        this._eventListeners.removeListeners(),
        this.pause(),
        this.particles.clear(),
        this.canvas.stop(),
        this.interactivity.element instanceof HTMLElement &&
          this._intersectionObserver &&
          this._intersectionObserver.unobserve(this.interactivity.element));
      for (const r of this.plugins.values()) (e = r.stop) == null || e.call(r);
      for (const r of this.plugins.keys()) this.plugins.delete(r);
      ((this._sourceOptions = this._options),
        this._engine.dispatchEvent(bt.containerStopped, { container: this }));
    }
  }
  updateActualOptions() {
    this.actualOptions.responsive = [];
    const e = this.actualOptions.setResponsive(
      this.canvas.size.width,
      this.retina.pixelRatio,
      this._options,
    );
    return (
      this.actualOptions.setTheme(this._currentTheme),
      this._responsiveMaxWidth === e ? !1 : ((this._responsiveMaxWidth = e), !0)
    );
  }
};
class a8 {
  constructor() {
    this._listeners = new Map();
  }
  addEventListener(e, r) {
    this.removeEventListener(e, r);
    let o = this._listeners.get(e);
    (o || ((o = []), this._listeners.set(e, o)), o.push(r));
  }
  dispatchEvent(e, r) {
    const o = this._listeners.get(e);
    o == null || o.forEach((l) => l(r));
  }
  hasEventListener(e) {
    return !!this._listeners.get(e);
  }
  removeAllEventListeners(e) {
    e ? this._listeners.delete(e) : (this._listeners = new Map());
  }
  removeEventListener(e, r) {
    const o = this._listeners.get(e);
    if (!o) return;
    const l = o.length,
      u = o.indexOf(r);
    if (u < 0) return;
    const d = 1;
    l === d ? this._listeners.delete(e) : o.splice(u, d);
  }
}
async function kc(n, e, r, o = !1) {
  let l = e.get(n);
  return (
    (!l || o) &&
      ((l = await Promise.all([...r.values()].map((u) => u(n)))), e.set(n, l)),
    l
  );
}
async function u8(n) {
  const e = ct(n.url, n.index);
  if (!e) return n.fallback;
  const r = await fetch(e);
  return r.ok
    ? await r.json()
    : (Gi().error(`${Kt} ${r.status} while retrieving config file`),
      n.fallback);
}
const D1 = "true",
  Ch = "false",
  Sc = "canvas",
  c8 = (n) => {
    let e;
    if (n instanceof HTMLCanvasElement || n.tagName.toLowerCase() === Sc)
      ((e = n), e.dataset[Fi] || (e.dataset[Fi] = Ch));
    else {
      const o = n.getElementsByTagName(Sc);
      o.length
        ? ((e = o[0]), (e.dataset[Fi] = Ch))
        : ((e = document.createElement(Sc)),
          (e.dataset[Fi] = D1),
          n.appendChild(e));
    }
    const r = "100%";
    return (
      e.style.width || (e.style.width = r),
      e.style.height || (e.style.height = r),
      e
    );
  },
  f8 = (n, e) => {
    let r = e ?? document.getElementById(n);
    return (
      r ||
      ((r = document.createElement("div")),
      (r.id = n),
      (r.dataset[Fi] = D1),
      document.body.append(r),
      r)
    );
  };
class d8 {
  constructor() {
    ((this._configs = new Map()),
      (this._domArray = []),
      (this._eventDispatcher = new a8()),
      (this._initialized = !1),
      (this.plugins = []),
      (this.colorManagers = new Map()),
      (this.easingFunctions = new Map()),
      (this._initializers = {
        interactors: new Map(),
        movers: new Map(),
        updaters: new Map(),
      }),
      (this.interactors = new Map()),
      (this.movers = new Map()),
      (this.updaters = new Map()),
      (this.presets = new Map()),
      (this.effectDrawers = new Map()),
      (this.shapeDrawers = new Map()),
      (this.pathGenerators = new Map()));
  }
  get configs() {
    const e = {};
    for (const [r, o] of this._configs) e[r] = o;
    return e;
  }
  get items() {
    return this._domArray;
  }
  get version() {
    return "3.7.1";
  }
  async addColorManager(e, r = !0) {
    (this.colorManagers.set(e.key, e), await this.refresh(r));
  }
  addConfig(e) {
    const r = e.key ?? e.name ?? "default";
    (this._configs.set(r, e),
      this._eventDispatcher.dispatchEvent(bt.configAdded, {
        data: { name: r, config: e },
      }));
  }
  async addEasing(e, r, o = !0) {
    this.getEasing(e) ||
      (this.easingFunctions.set(e, r), await this.refresh(o));
  }
  async addEffect(e, r, o = !0) {
    (Ke(e, (l) => {
      this.getEffectDrawer(l) || this.effectDrawers.set(l, r);
    }),
      await this.refresh(o));
  }
  addEventListener(e, r) {
    this._eventDispatcher.addEventListener(e, r);
  }
  async addInteractor(e, r, o = !0) {
    (this._initializers.interactors.set(e, r), await this.refresh(o));
  }
  async addMover(e, r, o = !0) {
    (this._initializers.movers.set(e, r), await this.refresh(o));
  }
  async addParticleUpdater(e, r, o = !0) {
    (this._initializers.updaters.set(e, r), await this.refresh(o));
  }
  async addPathGenerator(e, r, o = !0) {
    (this.getPathGenerator(e) || this.pathGenerators.set(e, r),
      await this.refresh(o));
  }
  async addPlugin(e, r = !0) {
    (this.getPlugin(e.id) || this.plugins.push(e), await this.refresh(r));
  }
  async addPreset(e, r, o = !1, l = !0) {
    ((o || !this.getPreset(e)) && this.presets.set(e, r),
      await this.refresh(l));
  }
  async addShape(e, r = !0) {
    for (const o of e.validTypes)
      this.getShapeDrawer(o) || this.shapeDrawers.set(o, e);
    await this.refresh(r);
  }
  clearPlugins(e) {
    (this.updaters.delete(e),
      this.movers.delete(e),
      this.interactors.delete(e));
  }
  dispatchEvent(e, r) {
    this._eventDispatcher.dispatchEvent(e, r);
  }
  dom() {
    return this.items;
  }
  domItem(e) {
    return this.item(e);
  }
  async getAvailablePlugins(e) {
    const r = new Map();
    for (const o of this.plugins)
      o.needsPlugin(e.actualOptions) && r.set(o.id, await o.getPlugin(e));
    return r;
  }
  getEasing(e) {
    return this.easingFunctions.get(e) ?? ((r) => r);
  }
  getEffectDrawer(e) {
    return this.effectDrawers.get(e);
  }
  async getInteractors(e, r = !1) {
    return kc(e, this.interactors, this._initializers.interactors, r);
  }
  async getMovers(e, r = !1) {
    return kc(e, this.movers, this._initializers.movers, r);
  }
  getPathGenerator(e) {
    return this.pathGenerators.get(e);
  }
  getPlugin(e) {
    return this.plugins.find((r) => r.id === e);
  }
  getPreset(e) {
    return this.presets.get(e);
  }
  getShapeDrawer(e) {
    return this.shapeDrawers.get(e);
  }
  getSupportedEffects() {
    return this.effectDrawers.keys();
  }
  getSupportedShapes() {
    return this.shapeDrawers.keys();
  }
  async getUpdaters(e, r = !1) {
    return kc(e, this.updaters, this._initializers.updaters, r);
  }
  init() {
    this._initialized || (this._initialized = !0);
  }
  item(e) {
    const { items: r } = this,
      o = r[e];
    if (!o || o.destroyed) {
      r.splice(e, 1);
      return;
    }
    return o;
  }
  async load(e) {
    var b;
    const o =
        e.id ??
        ((b = e.element) == null ? void 0 : b.id) ??
        `tsparticles${Math.floor(se() * 1e4)}`,
      { index: l, url: u } = e,
      c = u ? await u8({ fallback: e.options, url: u, index: l }) : e.options,
      d = ct(c, l),
      { items: p } = this,
      m = p.findIndex((_) => _.id.description === o),
      g = 0,
      v = new l8(this, o, d);
    if (m >= g) {
      const _ = this.item(m),
        E = 1,
        T = 0,
        D = _ ? E : T;
      (_ && !_.destroyed && _.destroy(!1), p.splice(m, D, v));
    } else p.push(v);
    const C = f8(o, e.element),
      x = c8(C);
    return (v.canvas.loadCanvas(x), await v.start(), v);
  }
  loadOptions(e, r) {
    this.plugins.forEach((o) => {
      var l;
      return (l = o.loadOptions) == null ? void 0 : l.call(o, e, r);
    });
  }
  loadParticlesOptions(e, r, ...o) {
    const l = this.updaters.get(e);
    l &&
      l.forEach((u) => {
        var c;
        return (c = u.loadOptions) == null ? void 0 : c.call(u, r, ...o);
      });
  }
  async refresh(e = !0) {
    e && (await Promise.all(this.items.map((r) => r.refresh())));
  }
  removeEventListener(e, r) {
    this._eventDispatcher.removeEventListener(e, r);
  }
  setOnClickHandler(e) {
    const { items: r } = this;
    if (!r.length)
      throw new Error(
        `${Kt} can only set click handlers after calling tsParticles.load()`,
      );
    r.forEach((o) => o.addClickHandler(e));
  }
}
function h8() {
  const n = new d8();
  return (n.init(), n);
}
class pn {
  constructor(e) {
    ((this.type = qr.external), (this.container = e));
  }
}
class x3 {
  constructor(e) {
    ((this.type = qr.particles), (this.container = e));
  }
}
var yt;
(function (n) {
  ((n.clockwise = "clockwise"),
    (n.counterClockwise = "counter-clockwise"),
    (n.random = "random"));
})(yt || (yt = {}));
var wh;
(function (n) {
  ((n.linear = "linear"), (n.radial = "radial"), (n.random = "random"));
})(wh || (wh = {}));
var Ui;
(function (n) {
  ((n.easeInBack = "ease-in-back"),
    (n.easeInCirc = "ease-in-circ"),
    (n.easeInCubic = "ease-in-cubic"),
    (n.easeInLinear = "ease-in-linear"),
    (n.easeInQuad = "ease-in-quad"),
    (n.easeInQuart = "ease-in-quart"),
    (n.easeInQuint = "ease-in-quint"),
    (n.easeInExpo = "ease-in-expo"),
    (n.easeInSine = "ease-in-sine"),
    (n.easeOutBack = "ease-out-back"),
    (n.easeOutCirc = "ease-out-circ"),
    (n.easeOutCubic = "ease-out-cubic"),
    (n.easeOutLinear = "ease-out-linear"),
    (n.easeOutQuad = "ease-out-quad"),
    (n.easeOutQuart = "ease-out-quart"),
    (n.easeOutQuint = "ease-out-quint"),
    (n.easeOutExpo = "ease-out-expo"),
    (n.easeOutSine = "ease-out-sine"),
    (n.easeInOutBack = "ease-in-out-back"),
    (n.easeInOutCirc = "ease-in-out-circ"),
    (n.easeInOutCubic = "ease-in-out-cubic"),
    (n.easeInOutLinear = "ease-in-out-linear"),
    (n.easeInOutQuad = "ease-in-out-quad"),
    (n.easeInOutQuart = "ease-in-out-quart"),
    (n.easeInOutQuint = "ease-in-out-quint"),
    (n.easeInOutExpo = "ease-in-out-expo"),
    (n.easeInOutSine = "ease-in-out-sine"));
})(Ui || (Ui = {}));
const _3 = h8();
Qi() || (window.tsParticles = _3);
class p8 {
  constructor() {
    ((this.radius = 0), (this.mass = 0));
  }
  load(e) {
    $(e) ||
      (e.mass !== void 0 && (this.mass = e.mass),
      e.radius !== void 0 && (this.radius = e.radius));
  }
}
class m8 extends hn {
  constructor() {
    (super(), (this.density = 5), (this.value = 50), (this.limit = new p8()));
  }
  load(e) {
    $(e) ||
      (super.load(e),
      e.density !== void 0 && (this.density = e.density),
      jt(e.limit) ? (this.limit.radius = e.limit) : this.limit.load(e.limit));
  }
}
class Vl {
  constructor() {
    ((this.color = new Ve()),
      (this.color.value = "#000000"),
      (this.draggable = !1),
      (this.opacity = 1),
      (this.destroy = !0),
      (this.orbits = !1),
      (this.size = new m8()));
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.draggable !== void 0 && (this.draggable = e.draggable),
      (this.name = e.name),
      e.opacity !== void 0 && (this.opacity = e.opacity),
      e.position !== void 0 &&
        ((this.position = {}),
        e.position.x !== void 0 && (this.position.x = ee(e.position.x)),
        e.position.y !== void 0 && (this.position.y = ee(e.position.y))),
      e.size !== void 0 && this.size.load(e.size),
      e.destroy !== void 0 && (this.destroy = e.destroy),
      e.orbits !== void 0 && (this.orbits = e.orbits));
  }
}
var Wl;
(function (n) {
  n.absorber = "absorber";
})(Wl || (Wl = {}));
const y8 = 2,
  g8 = 0.033,
  v8 = 0,
  C8 = 0,
  w8 = 0,
  xh = { x: 0, y: 0 },
  x8 = 0,
  _8 = 2,
  _h = Math.PI * _8,
  bh = 0;
class b8 {
  constructor(e, r, o, l, u) {
    var d;
    ((this._calcPosition = () => {
      const p = f1({
        size: this._container.canvas.size,
        position: this.options.position,
      });
      return ze.create(p.x, p.y);
    }),
      (this._updateParticlePosition = (p, m) => {
        if (p.destroyed) return;
        const g = this._container,
          v = g.canvas.size;
        if (p.needsNewPosition) {
          const C = c1({ size: v });
          (p.position.setTo(C),
            p.velocity.setTo(p.initialVelocity),
            (p.absorberOrbit = void 0),
            (p.needsNewPosition = !1));
        }
        if (this.options.orbits) {
          if (
            (p.absorberOrbit === void 0 &&
              ((p.absorberOrbit = ze.origin),
              (p.absorberOrbit.length = kt(p.getPosition(), this.position)),
              (p.absorberOrbit.angle = se() * _h)),
            p.absorberOrbit.length <= this.size && !this.options.destroy)
          ) {
            const E = Math.min(v.width, v.height),
              T = 1,
              D = 0.1,
              I = 0.2;
            p.absorberOrbit.length = E * (T + (se() * I - D));
          }
          p.absorberOrbitDirection === void 0 &&
            (p.absorberOrbitDirection =
              p.velocity.x >= bh ? yt.clockwise : yt.counterClockwise);
          const C = p.absorberOrbit.length,
            x = p.absorberOrbit.angle,
            b = p.absorberOrbitDirection;
          p.velocity.setTo(ze.origin);
          const _ = {
            x: b === yt.clockwise ? Math.cos : Math.sin,
            y: b === yt.clockwise ? Math.sin : Math.cos,
          };
          ((p.position.x = this.position.x + C * _.x(x)),
            (p.position.y = this.position.y + C * _.y(x)),
            (p.absorberOrbit.length -= m.length),
            (p.absorberOrbit.angle +=
              (((p.retina.moveSpeed ?? bh) * g.retina.pixelRatio) / at) *
              g.retina.reduceFactor));
        } else {
          const C = ze.origin;
          ((C.length = m.length), (C.angle = m.angle), p.velocity.addTo(C));
        }
      }),
      (this._absorbers = e),
      (this._container = r),
      (this._engine = o),
      (this.initialPosition = u ? ze.create(u.x, u.y) : void 0),
      l instanceof Vl
        ? (this.options = l)
        : ((this.options = new Vl()), this.options.load(l)),
      (this.dragging = !1),
      (this.name = this.options.name),
      (this.opacity = this.options.opacity),
      (this.size = H(this.options.size.value) * r.retina.pixelRatio),
      (this.mass =
        this.size * this.options.size.density * r.retina.reduceFactor));
    const c = this.options.size.limit;
    ((this.limit = {
      radius: c.radius * r.retina.pixelRatio * r.retina.reduceFactor,
      mass: c.mass,
    }),
      (this.color = Qt(this._engine, this.options.color) ?? {
        b: 0,
        g: 0,
        r: 0,
      }),
      (this.position =
        ((d = this.initialPosition) == null ? void 0 : d.copy()) ??
        this._calcPosition()));
  }
  attract(e) {
    const r = this._container,
      o = this.options;
    if (o.draggable) {
      const m = r.interactivity.mouse;
      (m.clicking && m.downPosition
        ? kt(this.position, m.downPosition) <= this.size && (this.dragging = !0)
        : (this.dragging = !1),
        this.dragging &&
          m.position &&
          ((this.position.x = m.position.x), (this.position.y = m.position.y)));
    }
    const l = e.getPosition(),
      { dx: u, dy: c, distance: d } = Ct(this.position, l),
      p = ze.create(u, c);
    if (
      ((p.length = (this.mass / Math.pow(d, y8)) * r.retina.reduceFactor),
      d < this.size + e.getRadius())
    ) {
      const m = e.getRadius() * g8 * r.retina.pixelRatio;
      ((this.size > e.getRadius() && d < this.size - e.getRadius()) ||
      (e.absorberOrbit !== void 0 && e.absorberOrbit.length < v8)
        ? o.destroy
          ? e.destroy()
          : ((e.needsNewPosition = !0), this._updateParticlePosition(e, p))
        : (o.destroy && (e.size.value -= m),
          this._updateParticlePosition(e, p)),
        (this.limit.radius <= C8 || this.size < this.limit.radius) &&
          (this.size += m),
        (this.limit.mass <= w8 || this.mass < this.limit.mass) &&
          (this.mass += m * this.options.size.density * r.retina.reduceFactor));
    } else this._updateParticlePosition(e, p);
  }
  draw(e) {
    (e.translate(this.position.x, this.position.y),
      e.beginPath(),
      e.arc(xh.x, xh.y, this.size, x8, _h, !1),
      e.closePath(),
      (e.fillStyle = Sn(this.color, this.opacity)),
      e.fill());
  }
  resize() {
    const e = this.initialPosition;
    this.position =
      e && Xo(e, this._container.canvas.size, ze.origin)
        ? e
        : this._calcPosition();
  }
}
const kh = 0;
class k8 {
  constructor(e, r) {
    ((this._container = e),
      (this._engine = r),
      (this.array = []),
      (this.absorbers = []),
      (this.interactivityAbsorbers = []),
      (e.getAbsorber = (o) =>
        o === void 0 || jt(o)
          ? this.array[o ?? kh]
          : this.array.find((l) => l.name === o)),
      (e.addAbsorber = async (o, l) => this.addAbsorber(o, l)));
  }
  async addAbsorber(e, r) {
    const o = new b8(this, this._container, this._engine, e, r);
    return (this.array.push(o), Promise.resolve(o));
  }
  draw(e) {
    for (const r of this.array) r.draw(e);
  }
  handleClickMode(e) {
    const r = this.absorbers,
      o = this.interactivityAbsorbers;
    if (e === Wl.absorber) {
      const l = ct(o),
        u = l ?? ct(r),
        c = this._container.interactivity.mouse.clickPosition;
      this.addAbsorber(u, c);
    }
  }
  async init() {
    ((this.absorbers = this._container.actualOptions.absorbers),
      (this.interactivityAbsorbers =
        this._container.actualOptions.interactivity.modes.absorbers));
    const e = Ke(this.absorbers, async (r) => {
      await this.addAbsorber(r);
    });
    e instanceof Array ? await Promise.all(e) : await e;
  }
  particleUpdate(e) {
    for (const r of this.array) if ((r.attract(e), e.destroyed)) break;
  }
  removeAbsorber(e) {
    const r = this.array.indexOf(e);
    r >= kh && this.array.splice(r, 1);
  }
  resize() {
    for (const e of this.array) e.resize();
  }
  stop() {
    this.array = [];
  }
}
class S8 {
  constructor(e) {
    ((this.id = "absorbers"), (this._engine = e));
  }
  async getPlugin(e) {
    return Promise.resolve(new k8(e, this._engine));
  }
  loadOptions(e, r) {
    var o, l;
    (!this.needsPlugin(e) && !this.needsPlugin(r)) ||
      (r != null &&
        r.absorbers &&
        (e.absorbers = Ke(r.absorbers, (u) => {
          const c = new Vl();
          return (c.load(u), c);
        })),
      (e.interactivity.modes.absorbers = Ke(
        (l =
          (o = r == null ? void 0 : r.interactivity) == null
            ? void 0
            : o.modes) == null
          ? void 0
          : l.absorbers,
        (u) => {
          const c = new Vl();
          return (c.load(u), c);
        },
      )));
  }
  needsPlugin(e) {
    var o, l, u;
    if (!e) return !1;
    const r = e.absorbers;
    return vt(r)
      ? !!r.length
      : r
        ? !0
        : !!(
            (u =
              (l = (o = e.interactivity) == null ? void 0 : o.events) == null
                ? void 0
                : l.onClick) != null &&
            u.mode &&
            Oe(Wl.absorber, e.interactivity.events.onClick.mode)
          );
  }
}
async function E8(n, e = !0) {
  (re(n, "3.7.1"), await n.addPlugin(new S8(n), e));
}
class P8 {
  load(e) {
    $(e) ||
      (e.bottom !== void 0 && (this.bottom = ee(e.bottom)),
      e.left !== void 0 && (this.left = ee(e.left)),
      e.right !== void 0 && (this.right = ee(e.right)),
      e.top !== void 0 && (this.top = ee(e.top)));
  }
}
var ql;
(function (n) {
  ((n.none = "none"), (n.split = "split"));
})(ql || (ql = {}));
class z8 extends hn {
  constructor() {
    (super(), (this.value = 3));
  }
}
class O8 extends hn {
  constructor() {
    (super(), (this.value = { min: 4, max: 9 }));
  }
}
class M8 {
  constructor() {
    ((this.count = 1),
      (this.factor = new z8()),
      (this.rate = new O8()),
      (this.sizeOffset = !0));
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.count !== void 0 && (this.count = e.count),
      this.factor.load(e.factor),
      this.rate.load(e.rate),
      (this.particles = Ke(e.particles, (r) => je({}, r))),
      e.sizeOffset !== void 0 && (this.sizeOffset = e.sizeOffset),
      e.colorOffset &&
        ((this.colorOffset = this.colorOffset ?? {}),
        e.colorOffset.h !== void 0 && (this.colorOffset.h = e.colorOffset.h),
        e.colorOffset.s !== void 0 && (this.colorOffset.s = e.colorOffset.s),
        e.colorOffset.l !== void 0 && (this.colorOffset.l = e.colorOffset.l)));
  }
}
class R8 {
  constructor() {
    ((this.bounds = new P8()), (this.mode = ql.none), (this.split = new M8()));
  }
  load(e) {
    $(e) ||
      (e.mode && (this.mode = e.mode),
      e.bounds && this.bounds.load(e.bounds),
      this.split.load(e.split));
  }
}
const ml = 0,
  D8 = 0.5,
  T8 = 0,
  I8 = 1,
  L8 = 500,
  F8 = 0;
function A8(n, e, r, o) {
  const l = r.options.destroy;
  if (!l) return;
  const u = l.split,
    c = w3(n, e, r.options),
    d = H(u.factor.value),
    p = r.getFillColor();
  (u.color
    ? c.color.load(u.color)
    : u.colorOffset && p
      ? c.color.load({
          value: {
            hsl: {
              h: p.h + H(u.colorOffset.h ?? ml),
              s: p.s + H(u.colorOffset.s ?? ml),
              l: p.l + H(u.colorOffset.l ?? ml),
            },
          },
        })
      : c.color.load({ value: { hsl: r.getFillColor() } }),
    c.move.load({
      center: { x: r.position.x, y: r.position.y, mode: En.precise },
    }),
    jt(c.size.value)
      ? (c.size.value /= d)
      : ((c.size.value.min /= d), (c.size.value.max /= d)),
    c.load(o));
  const m = u.sizeOffset ? ee(-r.size.value, r.size.value) : ml,
    g = { x: r.position.x + ut(m), y: r.position.y + ut(m) };
  return e.particles.addParticle(g, c, r.group, (v) =>
    v.size.value < D8
      ? !1
      : ((v.velocity.length = ut(ee(r.velocity.length, v.velocity.length))),
        (v.splitCount = (r.splitCount ?? T8) + I8),
        (v.unbreakable = !0),
        setTimeout(() => {
          v.unbreakable = !1;
        }, L8),
        !0),
  );
}
function N8(n, e, r) {
  const o = r.options.destroy;
  if (!o) return;
  const l = o.split;
  if (l.count >= F8 && (r.splitCount === void 0 || r.splitCount++ > l.count))
    return;
  const u = H(l.rate.value),
    c = ct(l.particles);
  for (let d = 0; d < u; d++) A8(n, e, r, c);
}
class $8 {
  constructor(e, r) {
    ((this.container = r), (this.engine = e));
  }
  init(e) {
    const r = this.container,
      o = e.options,
      l = o.destroy;
    if (!l) return;
    e.splitCount = 0;
    const u = l.bounds;
    e.destroyBounds || (e.destroyBounds = {});
    const { bottom: c, left: d, right: p, top: m } = u,
      { destroyBounds: g } = e,
      v = r.canvas.size;
    (c && (g.bottom = (H(c) * v.height) / at),
      d && (g.left = (H(d) * v.width) / at),
      p && (g.right = (H(p) * v.width) / at),
      m && (g.top = (H(m) * v.height) / at));
  }
  isEnabled(e) {
    return !e.destroyed;
  }
  loadOptions(e, ...r) {
    e.destroy || (e.destroy = new R8());
    for (const o of r) e.destroy.load(o == null ? void 0 : o.destroy);
  }
  particleDestroyed(e, r) {
    if (r) return;
    const o = e.options.destroy;
    o && o.mode === ql.split && N8(this.engine, this.container, e);
  }
  update(e) {
    if (!this.isEnabled(e)) return;
    const r = e.getPosition(),
      o = e.destroyBounds;
    o &&
      ((o.bottom !== void 0 && r.y >= o.bottom) ||
        (o.left !== void 0 && r.x <= o.left) ||
        (o.right !== void 0 && r.x >= o.right) ||
        (o.top !== void 0 && r.y <= o.top)) &&
      e.destroy();
  }
}
async function j8(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater(
      "destroy",
      (r) => Promise.resolve(new $8(n, r)),
      e,
    ));
}
class B8 {
  constructor() {
    this.wait = !1;
  }
  load(e) {
    $(e) ||
      (e.count !== void 0 && (this.count = e.count),
      e.delay !== void 0 && (this.delay = ee(e.delay)),
      e.duration !== void 0 && (this.duration = ee(e.duration)),
      e.wait !== void 0 && (this.wait = e.wait));
  }
}
class U8 {
  constructor() {
    ((this.quantity = 1), (this.delay = 0.1));
  }
  load(e) {
    $(e) ||
      (e.quantity !== void 0 && (this.quantity = ee(e.quantity)),
      e.delay !== void 0 && (this.delay = ee(e.delay)));
  }
}
class H8 {
  constructor() {
    ((this.color = !1), (this.opacity = !1));
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = e.color),
      e.opacity !== void 0 && (this.opacity = e.opacity));
  }
}
class V8 {
  constructor() {
    ((this.options = {}), (this.replace = new H8()), (this.type = "square"));
  }
  load(e) {
    $(e) ||
      (e.options !== void 0 && (this.options = je({}, e.options ?? {})),
      this.replace.load(e.replace),
      e.type !== void 0 && (this.type = e.type));
  }
}
class T1 {
  constructor() {
    ((this.mode = En.percent), (this.height = 0), (this.width = 0));
  }
  load(e) {
    $(e) ||
      (e.mode !== void 0 && (this.mode = e.mode),
      e.height !== void 0 && (this.height = e.height),
      e.width !== void 0 && (this.width = e.width));
  }
}
class ui {
  constructor() {
    ((this.autoPlay = !0),
      (this.fill = !0),
      (this.life = new B8()),
      (this.rate = new U8()),
      (this.shape = new V8()),
      (this.startCount = 0));
  }
  load(e) {
    $(e) ||
      (e.autoPlay !== void 0 && (this.autoPlay = e.autoPlay),
      e.size !== void 0 &&
        (this.size || (this.size = new T1()), this.size.load(e.size)),
      e.direction !== void 0 && (this.direction = e.direction),
      (this.domId = e.domId),
      e.fill !== void 0 && (this.fill = e.fill),
      this.life.load(e.life),
      (this.name = e.name),
      (this.particles = Ke(e.particles, (r) => je({}, r))),
      this.rate.load(e.rate),
      this.shape.load(e.shape),
      e.position !== void 0 &&
        ((this.position = {}),
        e.position.x !== void 0 && (this.position.x = ee(e.position.x)),
        e.position.y !== void 0 && (this.position.y = ee(e.position.y))),
      e.spawnColor !== void 0 &&
        (this.spawnColor === void 0 && (this.spawnColor = new Wr()),
        this.spawnColor.load(e.spawnColor)),
      e.startCount !== void 0 && (this.startCount = e.startCount));
  }
}
var Gl;
(function (n) {
  n.emitter = "emitter";
})(Gl || (Gl = {}));
const Sh = 0.5,
  Eh = 0,
  yl = 0,
  Ph = 0,
  W8 = 0,
  q8 = -1,
  G8 = 1;
function zh(n, e) {
  n.color ? (n.color.value = e) : (n.color = { value: e });
}
class Q8 {
  constructor(e, r, o, l, u) {
    var m, g;
    ((this.emitters = r),
      (this.container = o),
      (this._destroy = () => {
        var v, C;
        ((v = this._mutationObserver) == null || v.disconnect(),
          (this._mutationObserver = void 0),
          (C = this._resizeObserver) == null || C.disconnect(),
          (this._resizeObserver = void 0),
          this.emitters.removeEmitter(this),
          this._engine.dispatchEvent("emitterDestroyed", {
            container: this.container,
            data: { emitter: this },
          }));
      }),
      (this._prepareToDie = () => {
        var b;
        if (this._paused) return;
        const v =
          ((b = this.options.life) == null ? void 0 : b.duration) !== void 0
            ? H(this.options.life.duration)
            : void 0;
        this.container.retina.reduceFactor &&
          (this._lifeCount > 0 || this._immortal) &&
          v !== void 0 &&
          v > 0 &&
          (this._duration = v * Fe);
      }),
      (this._setColorAnimation = (v, C, x, b = G8) => {
        const _ = this.container;
        if (!v.enable) return C;
        const E = ut(v.offset),
          T = H(this.options.rate.delay),
          D = (T * Fe) / _.retina.reduceFactor,
          I = 0,
          R = H(v.speed ?? I);
        return (C + (R * _.fpsLimit) / D + E * b) % x;
      }),
      (this._engine = e),
      (this._currentDuration = 0),
      (this._currentEmitDelay = 0),
      (this._currentSpawnDelay = 0),
      (this._initialPosition = u),
      l instanceof ui
        ? (this.options = l)
        : ((this.options = new ui()), this.options.load(l)),
      (this._spawnDelay =
        (H(this.options.life.delay ?? Eh) * Fe) /
        this.container.retina.reduceFactor),
      (this.position = this._initialPosition ?? this._calcPosition()),
      (this.name = this.options.name),
      (this.fill = this.options.fill),
      (this._firstSpawn = !this.options.life.wait),
      (this._startParticlesAdded = !1));
    let c = je({}, this.options.particles);
    if (
      (c ?? (c = {}),
      c.move ?? (c.move = {}),
      (m = c.move).direction ?? (m.direction = this.options.direction),
      this.options.spawnColor &&
        (this.spawnColor = mi(this._engine, this.options.spawnColor)),
      (this._paused = !this.options.autoPlay),
      (this._particlesOptions = c),
      (this._size = this._calcSize()),
      (this.size = rh(this._size, this.container.canvas.size)),
      (this._lifeCount = this.options.life.count ?? q8),
      (this._immortal = this._lifeCount <= yl),
      this.options.domId)
    ) {
      const v = document.getElementById(this.options.domId);
      v &&
        ((this._mutationObserver = new MutationObserver(() => {
          this.resize();
        })),
        (this._resizeObserver = new ResizeObserver(() => {
          this.resize();
        })),
        this._mutationObserver.observe(v, {
          attributes: !0,
          attributeFilter: ["style", "width", "height"],
        }),
        this._resizeObserver.observe(v));
    }
    const d = this.options.shape,
      p =
        (g = this._engine.emitterShapeManager) == null
          ? void 0
          : g.getShapeGenerator(d.type);
    (p &&
      (this._shape = p.generate(
        this.position,
        this.size,
        this.fill,
        d.options,
      )),
      this._engine.dispatchEvent("emitterCreated", {
        container: o,
        data: { emitter: this },
      }),
      this.play());
  }
  externalPause() {
    ((this._paused = !0), this.pause());
  }
  externalPlay() {
    ((this._paused = !1), this.play());
  }
  async init() {
    var e;
    await ((e = this._shape) == null ? void 0 : e.init());
  }
  pause() {
    this._paused || delete this._emitDelay;
  }
  play() {
    if (
      !this._paused &&
      this.container.retina.reduceFactor &&
      (this._lifeCount > yl || this._immortal || !this.options.life.count) &&
      (this._firstSpawn || this._currentSpawnDelay >= (this._spawnDelay ?? Ph))
    ) {
      if (this._emitDelay === void 0) {
        const e = H(this.options.rate.delay);
        this._emitDelay = (e * Fe) / this.container.retina.reduceFactor;
      }
      (this._lifeCount > yl || this._immortal) && this._prepareToDie();
    }
  }
  resize() {
    var r;
    const e = this._initialPosition;
    ((this.position =
      e && Xo(e, this.container.canvas.size, ze.origin)
        ? e
        : this._calcPosition()),
      (this._size = this._calcSize()),
      (this.size = rh(this._size, this.container.canvas.size)),
      (r = this._shape) == null || r.resize(this.position, this.size));
  }
  update(e) {
    var r;
    this._paused ||
      (this._firstSpawn &&
        ((this._firstSpawn = !1),
        (this._currentSpawnDelay = this._spawnDelay ?? Ph),
        (this._currentEmitDelay = this._emitDelay ?? W8)),
      this._startParticlesAdded ||
        ((this._startParticlesAdded = !0),
        this._emitParticles(this.options.startCount)),
      this._duration !== void 0 &&
        ((this._currentDuration += e.value),
        this._currentDuration >= this._duration &&
          (this.pause(),
          this._spawnDelay !== void 0 && delete this._spawnDelay,
          this._immortal || this._lifeCount--,
          this._lifeCount > yl || this._immortal
            ? ((this.position = this._calcPosition()),
              (r = this._shape) == null || r.resize(this.position, this.size),
              (this._spawnDelay =
                (H(this.options.life.delay ?? Eh) * Fe) /
                this.container.retina.reduceFactor))
            : this._destroy(),
          (this._currentDuration -= this._duration),
          delete this._duration)),
      this._spawnDelay !== void 0 &&
        ((this._currentSpawnDelay += e.value),
        this._currentSpawnDelay >= this._spawnDelay &&
          (this._engine.dispatchEvent("emitterPlay", {
            container: this.container,
          }),
          this.play(),
          (this._currentSpawnDelay -= this._currentSpawnDelay),
          delete this._spawnDelay)),
      this._emitDelay !== void 0 &&
        ((this._currentEmitDelay += e.value),
        this._currentEmitDelay >= this._emitDelay &&
          (this._emit(), (this._currentEmitDelay -= this._emitDelay))));
  }
  _calcPosition() {
    if (this.options.domId) {
      const e = document.getElementById(this.options.domId);
      if (e) {
        const r = e.getBoundingClientRect(),
          o = this.container.retina.pixelRatio;
        return { x: (r.x + r.width * Sh) * o, y: (r.y + r.height * Sh) * o };
      }
    }
    return f1({
      size: this.container.canvas.size,
      position: this.options.position,
    });
  }
  _calcSize() {
    const e = this.container;
    if (this.options.domId) {
      const r = document.getElementById(this.options.domId);
      if (r) {
        const o = r.getBoundingClientRect();
        return {
          width: o.width * e.retina.pixelRatio,
          height: o.height * e.retina.pixelRatio,
          mode: En.precise,
        };
      }
    }
    return (
      this.options.size ??
      (() => {
        const r = new T1();
        return (r.load({ height: 0, mode: En.percent, width: 0 }), r);
      })()
    );
  }
  _emit() {
    if (this._paused) return;
    const e = H(this.options.rate.quantity);
    this._emitParticles(e);
  }
  _emitParticles(e) {
    var o;
    const r = ct(this._particlesOptions);
    for (let l = 0; l < e; l++) {
      const u = je({}, r);
      if (this.spawnColor) {
        const p = (o = this.options.spawnColor) == null ? void 0 : o.animation;
        if (p) {
          const m = { h: 360, s: 100, l: 100 },
            g = 3.6;
          ((this.spawnColor.h = this._setColorAnimation(
            p.h,
            this.spawnColor.h,
            m.h,
            g,
          )),
            (this.spawnColor.s = this._setColorAnimation(
              p.s,
              this.spawnColor.s,
              m.s,
            )),
            (this.spawnColor.l = this._setColorAnimation(
              p.l,
              this.spawnColor.l,
              m.l,
            )));
        }
        zh(u, this.spawnColor);
      }
      const c = this.options.shape;
      let d = this.position;
      if (this._shape) {
        const p = this._shape.randomPosition();
        if (p) {
          d = p.position;
          const m = c.replace;
          (m.color && p.color && zh(u, p.color),
            m.opacity &&
              (u.opacity
                ? (u.opacity.value = p.opacity)
                : (u.opacity = { value: p.opacity })));
        } else d = null;
      }
      d && this.container.particles.addParticle(d, u);
    }
  }
}
class Z8 {
  constructor(e, r) {
    ((this.container = r),
      (this._engine = e),
      (this.array = []),
      (this.emitters = []),
      (this.interactivityEmitters = {
        random: { count: 1, enable: !1 },
        value: [],
      }));
    const o = 0;
    ((r.getEmitter = (l) =>
      l === void 0 || jt(l)
        ? this.array[l ?? o]
        : this.array.find((u) => u.name === l)),
      (r.addEmitter = async (l, u) => this.addEmitter(l, u)),
      (r.removeEmitter = (l) => {
        const u = r.getEmitter(l);
        u && this.removeEmitter(u);
      }),
      (r.playEmitter = (l) => {
        const u = r.getEmitter(l);
        u && u.externalPlay();
      }),
      (r.pauseEmitter = (l) => {
        const u = r.getEmitter(l);
        u && u.externalPause();
      }));
  }
  async addEmitter(e, r) {
    const o = new ui();
    o.load(e);
    const l = new Q8(this._engine, this, this.container, o, r);
    return (await l.init(), this.array.push(l), l);
  }
  handleClickMode(e) {
    const r = this.emitters,
      o = this.interactivityEmitters;
    if (e !== Gl.emitter) return;
    let l;
    if (o && vt(o.value))
      if (o.value.length > 0 && o.random.enable) {
        l = [];
        const p = [];
        for (let m = 0; m < o.random.count; m++) {
          const g = p1(o.value);
          if (p.includes(g) && p.length < o.value.length) {
            m--;
            continue;
          }
          (p.push(g), l.push(Yo(o.value, g)));
        }
      } else l = o.value;
    else l = o == null ? void 0 : o.value;
    const u = l ?? r,
      c = this.container.interactivity.mouse.clickPosition;
    Ke(u, async (d) => {
      await this.addEmitter(d, c);
    });
  }
  async init() {
    if (
      ((this.emitters = this.container.actualOptions.emitters),
      (this.interactivityEmitters =
        this.container.actualOptions.interactivity.modes.emitters),
      !!this.emitters)
    )
      if (vt(this.emitters))
        for (const e of this.emitters) await this.addEmitter(e);
      else await this.addEmitter(this.emitters);
  }
  pause() {
    for (const e of this.array) e.pause();
  }
  play() {
    for (const e of this.array) e.play();
  }
  removeEmitter(e) {
    const r = this.array.indexOf(e);
    r >= 0 && this.array.splice(r, 1);
  }
  resize() {
    for (const e of this.array) e.resize();
  }
  stop() {
    this.array = [];
  }
  update(e) {
    for (const r of this.array) r.update(e);
  }
}
class K8 {
  constructor(e) {
    ((this._engine = e), (this.id = "emitters"));
  }
  getPlugin(e) {
    return Promise.resolve(new Z8(this._engine, e));
  }
  loadOptions(e, r) {
    var l, u;
    if (!this.needsPlugin(e) && !this.needsPlugin(r)) return;
    r != null &&
      r.emitters &&
      (e.emitters = Ke(r.emitters, (c) => {
        const d = new ui();
        return (d.load(c), d);
      }));
    const o =
      (u =
        (l = r == null ? void 0 : r.interactivity) == null
          ? void 0
          : l.modes) == null
        ? void 0
        : u.emitters;
    if (o)
      if (vt(o))
        e.interactivity.modes.emitters = {
          random: { count: 1, enable: !0 },
          value: o.map((c) => {
            const d = new ui();
            return (d.load(c), d);
          }),
        };
      else {
        const c = o;
        if (c.value !== void 0)
          if (vt(c.value))
            e.interactivity.modes.emitters = {
              random: {
                count: c.random.count ?? 1,
                enable: c.random.enable ?? !1,
              },
              value: c.value.map((p) => {
                const m = new ui();
                return (m.load(p), m);
              }),
            };
          else {
            const p = new ui();
            (p.load(c.value),
              (e.interactivity.modes.emitters = {
                random: {
                  count: c.random.count ?? 1,
                  enable: c.random.enable ?? !1,
                },
                value: p,
              }));
          }
        else
          (e.interactivity.modes.emitters = {
            random: { count: 1, enable: !1 },
            value: new ui(),
          }).value.load(o);
      }
  }
  needsPlugin(e) {
    var o, l, u;
    if (!e) return !1;
    const r = e.emitters;
    return (
      (vt(r) && !!r.length) ||
      r !== void 0 ||
      (!!(
        (u =
          (l = (o = e.interactivity) == null ? void 0 : o.events) == null
            ? void 0
            : l.onClick) != null && u.mode
      ) &&
        Oe(Gl.emitter, e.interactivity.events.onClick.mode))
    );
  }
}
const Ec = new Map();
class Y8 {
  constructor(e) {
    this._engine = e;
  }
  addShapeGenerator(e, r) {
    this.getShapeGenerator(e) || Ec.set(e, r);
  }
  getShapeGenerator(e) {
    return Ec.get(e);
  }
  getSupportedShapeGenerators() {
    return Ec.keys();
  }
}
class I1 {
  constructor(e, r, o, l) {
    ((this.position = e), (this.size = r), (this.fill = o), (this.options = l));
  }
  resize(e, r) {
    ((this.position = e), (this.size = r));
  }
}
async function X8(n, e = !0) {
  (re(n, "3.7.1"),
    n.emitterShapeManager || (n.emitterShapeManager = new Y8(n)),
    n.addEmitterShapeGenerator ||
      (n.addEmitterShapeGenerator = (o, l) => {
        var u;
        (u = n.emitterShapeManager) == null || u.addShapeGenerator(o, l);
      }));
  const r = new K8(n);
  await n.addPlugin(r, e);
}
const No = 0.25,
  t3 = 2,
  J8 = Math.PI * t3,
  Oh = 2,
  Mh = 0.5;
class em extends I1 {
  constructor(e, r, o, l) {
    super(e, r, o, l);
  }
  async init() {}
  randomPosition() {
    const e = this.size,
      r = this.fill,
      o = this.position,
      l = (v, C) => {
        const x = se() * No,
          b = Math.atan((C / v) * Math.tan(J8 * x)),
          _ = se();
        return _ < No
          ? b
          : _ < t3 * No
            ? Math.PI - b
            : _ < t3 * No + No
              ? Math.PI + b
              : -b;
      },
      u = (v, C, x) =>
        (v * C) / Math.sqrt((C * Math.cos(x)) ** Oh + (v * Math.sin(x)) ** Oh),
      [c, d] = [e.width * Mh, e.height * Mh],
      p = l(c, d),
      m = u(c, d, p),
      g = r ? m * Math.sqrt(se()) : m;
    return { position: { x: o.x + g * Math.cos(p), y: o.y + g * Math.sin(p) } };
  }
}
class tm {
  generate(e, r, o, l) {
    return new em(e, r, o, l);
  }
}
async function nm(n, e = !0) {
  var o;
  const r = n;
  (re(r, "3.7.1"),
    (o = r.addEmitterShapeGenerator) == null || o.call(r, "circle", new tm()),
    await r.refresh(e));
}
const Rh = 0.5,
  im = 4,
  rm = 2;
var Pr;
(function (n) {
  ((n[(n.TopLeft = 0)] = "TopLeft"),
    (n[(n.TopRight = 1)] = "TopRight"),
    (n[(n.BottomRight = 2)] = "BottomRight"),
    (n[(n.BottomLeft = 3)] = "BottomLeft"));
})(Pr || (Pr = {}));
function Dh(n, e) {
  return n + e * (se() - qi);
}
class om extends I1 {
  constructor(e, r, o, l) {
    super(e, r, o, l);
  }
  async init() {}
  randomPosition() {
    const e = this.fill,
      r = this.position,
      o = this.size;
    if (e) return { position: { x: Dh(r.x, o.width), y: Dh(r.y, o.height) } };
    {
      const l = o.width * Rh,
        u = o.height * Rh,
        c = Math.floor(se() * im),
        d = (se() - qi) * rm;
      switch (c) {
        case Pr.TopLeft:
          return { position: { x: r.x + d * l, y: r.y - u } };
        case Pr.TopRight:
          return { position: { x: r.x - l, y: r.y + d * u } };
        case Pr.BottomRight:
          return { position: { x: r.x + d * l, y: r.y + u } };
        case Pr.BottomLeft:
        default:
          return { position: { x: r.x + l, y: r.y + d * u } };
      }
    }
  }
}
class sm {
  generate(e, r, o, l) {
    return new om(e, r, o, l);
  }
}
async function lm(n, e = !0) {
  var o;
  const r = n;
  (re(r, "3.7.1"),
    (o = r.addEmitterShapeGenerator) == null || o.call(r, "square", new sm()),
    await r.refresh(e));
}
class am {
  constructor() {
    ((this.delay = 1), (this.pauseOnStop = !1), (this.quantity = 1));
  }
  load(e) {
    $(e) ||
      (e.delay !== void 0 && (this.delay = e.delay),
      e.quantity !== void 0 && (this.quantity = e.quantity),
      e.particles !== void 0 && (this.particles = je({}, e.particles)),
      e.pauseOnStop !== void 0 && (this.pauseOnStop = e.pauseOnStop));
  }
}
const Th = "trail";
class um extends pn {
  constructor(e) {
    (super(e), (this._delay = 0));
  }
  clear() {}
  init() {}
  interact(e) {
    var m, g, v, C;
    const r = this.container,
      { interactivity: o } = r;
    if (!r.retina.reduceFactor) return;
    const l = r.actualOptions,
      u = l.interactivity.modes.trail;
    if (!u) return;
    const c = (u.delay * Fe) / this.container.retina.reduceFactor;
    if ((this._delay < c && (this._delay += e.value), this._delay < c)) return;
    const d = !(
        u.pauseOnStop &&
        (o.mouse.position === this._lastPosition ||
          (((m = o.mouse.position) == null ? void 0 : m.x) ===
            ((g = this._lastPosition) == null ? void 0 : g.x) &&
            ((v = o.mouse.position) == null ? void 0 : v.y) ===
              ((C = this._lastPosition) == null ? void 0 : C.y)))
      ),
      p = r.interactivity.mouse.position;
    (p ? (this._lastPosition = { ...p }) : delete this._lastPosition,
      d && r.particles.push(u.quantity, r.interactivity.mouse, u.particles),
      (this._delay -= c));
  }
  isEnabled(e) {
    const r = this.container,
      o = r.actualOptions,
      l = r.interactivity.mouse,
      u = ((e == null ? void 0 : e.interactivity) ?? o.interactivity).events;
    return (
      (l.clicking && l.inside && !!l.position && Oe(Th, u.onClick.mode)) ||
      (l.inside && !!l.position && Oe(Th, u.onHover.mode))
    );
  }
  loadModeOptions(e, ...r) {
    e.trail || (e.trail = new am());
    for (const o of r) e.trail.load(o == null ? void 0 : o.trail);
  }
  reset() {}
}
async function cm(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalTrail",
      (r) => Promise.resolve(new um(r)),
      e,
    ));
}
var $i;
(function (n) {
  ((n.both = "both"), (n.horizontal = "horizontal"), (n.vertical = "vertical"));
})($i || ($i = {}));
const fm = 2,
  L1 = Math.PI * fm,
  dm = 360;
function hm(n, e) {
  const r = e.options.roll;
  if (!(r != null && r.enable)) {
    e.roll = { enable: !1, horizontal: !1, vertical: !1, angle: 0, speed: 0 };
    return;
  }
  if (
    ((e.roll = {
      enable: r.enable,
      horizontal: r.mode === $i.horizontal || r.mode === $i.both,
      vertical: r.mode === $i.vertical || r.mode === $i.both,
      angle: se() * L1,
      speed: H(r.speed) / dm,
    }),
    r.backColor)
  )
    e.backColor = mi(n, r.backColor);
  else if (r.darken.enable && r.enlighten.enable) {
    const o = se() >= qi ? li.darken : li.enlighten;
    e.roll.alter = {
      type: o,
      value: H(o === li.darken ? r.darken.value : r.enlighten.value),
    };
  } else
    r.darken.enable
      ? (e.roll.alter = { type: li.darken, value: H(r.darken.value) })
      : r.enlighten.enable &&
        (e.roll.alter = { type: li.enlighten, value: H(r.enlighten.value) });
}
function pm(n, e) {
  const r = n.options.roll,
    o = n.roll;
  if (!o || !(r != null && r.enable)) return;
  const l = o.speed * e.factor,
    u = L1;
  ((o.angle += l), o.angle > u && (o.angle -= u));
}
class Ih {
  constructor() {
    ((this.enable = !1), (this.value = 0));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.value !== void 0 && (this.value = ee(e.value)));
  }
}
class mm {
  constructor() {
    ((this.darken = new Ih()),
      (this.enable = !1),
      (this.enlighten = new Ih()),
      (this.mode = $i.vertical),
      (this.speed = 25));
  }
  load(e) {
    $(e) ||
      (e.backColor !== void 0 &&
        (this.backColor = Ve.create(this.backColor, e.backColor)),
      this.darken.load(e.darken),
      e.enable !== void 0 && (this.enable = e.enable),
      this.enlighten.load(e.enlighten),
      e.mode !== void 0 && (this.mode = e.mode),
      e.speed !== void 0 && (this.speed = ee(e.speed)));
  }
}
class ym {
  constructor(e) {
    this._engine = e;
  }
  getTransformValues(e) {
    var u;
    const r = ((u = e.roll) == null ? void 0 : u.enable) && e.roll,
      o = r && r.horizontal,
      l = r && r.vertical;
    return {
      a: o ? Math.cos(r.angle) : void 0,
      d: l ? Math.sin(r.angle) : void 0,
    };
  }
  init(e) {
    hm(this._engine, e);
  }
  isEnabled(e) {
    const r = e.options.roll;
    return !e.destroyed && !e.spawning && !!(r != null && r.enable);
  }
  loadOptions(e, ...r) {
    e.roll || (e.roll = new mm());
    for (const o of r) e.roll.load(o == null ? void 0 : o.roll);
  }
  update(e, r) {
    this.isEnabled(e) && pm(e, r);
  }
}
async function gm(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater("roll", () => Promise.resolve(new ym(n)), e));
}
const n3 = 0.5,
  ji = 0,
  un = 1,
  Lh = 60,
  Fh = 0,
  vm = 0.01;
function Cm(n) {
  const e = n.initialPosition,
    { dx: r, dy: o } = Ct(e, n.position),
    l = Math.abs(r),
    u = Math.abs(o),
    { maxDistance: c } = n.retina,
    d = c.horizontal,
    p = c.vertical;
  if (!d && !p) return;
  const m = (d && l >= d) ?? !1,
    g = (p && u >= p) ?? !1;
  if ((m || g) && !n.misplaced)
    ((n.misplaced = (!!d && l > d) || (!!p && u > p)),
      d && (n.velocity.x = n.velocity.y * n3 - n.velocity.x),
      p && (n.velocity.y = n.velocity.x * n3 - n.velocity.y));
  else if ((!d || l < d) && (!p || u < p) && n.misplaced) n.misplaced = !1;
  else if (n.misplaced) {
    const v = n.position,
      C = n.velocity;
    (d &&
      ((v.x < e.x && C.x < ji) || (v.x > e.x && C.x > ji)) &&
      (C.x *= -se()),
      p &&
        ((v.y < e.y && C.y < ji) || (v.y > e.y && C.y > ji)) &&
        (C.y *= -se()));
  }
}
function wm(n, e, r, o, l, u) {
  _m(n, u);
  const c = n.gravity,
    d = c != null && c.enable && c.inverse ? -un : un;
  (l && r && (n.velocity.x += (l * u.factor) / (Lh * r)),
    c != null &&
      c.enable &&
      r &&
      (n.velocity.y += (d * (c.acceleration * u.factor)) / (Lh * r)));
  const p = n.moveDecay;
  n.velocity.multTo(p);
  const m = n.velocity.mult(r);
  c != null &&
    c.enable &&
    o > ji &&
    ((!c.inverse && m.y >= ji && m.y >= o) ||
      (c.inverse && m.y <= ji && m.y <= -o)) &&
    ((m.y = d * o), r && (n.velocity.y = m.y / r));
  const g = n.options.zIndex,
    v = (un - n.zIndexFactor) ** g.velocityRate;
  m.multTo(v);
  const { position: C } = n;
  (C.addTo(m),
    e.vibrate &&
      ((C.x += Math.sin(C.x * Math.cos(C.y))),
      (C.y += Math.cos(C.y * Math.sin(C.x)))));
}
function xm(n, e) {
  const r = n.container;
  if (!n.spin) return;
  const o = {
    x: n.spin.direction === yt.clockwise ? Math.cos : Math.sin,
    y: n.spin.direction === yt.clockwise ? Math.sin : Math.cos,
  };
  ((n.position.x = n.spin.center.x + n.spin.radius * o.x(n.spin.angle)),
    (n.position.y = n.spin.center.y + n.spin.radius * o.y(n.spin.angle)),
    (n.spin.radius += n.spin.acceleration));
  const l = Math.max(r.canvas.size.width, r.canvas.size.height),
    u = l * n3;
  (n.spin.radius > u
    ? ((n.spin.radius = u), (n.spin.acceleration *= -un))
    : n.spin.radius < Fh &&
      ((n.spin.radius = Fh), (n.spin.acceleration *= -un)),
    (n.spin.angle += e * vm * (un - n.spin.radius / l)));
}
function _m(n, e) {
  var c;
  const r = n.options,
    o = r.move.path;
  if (!o.enable) return;
  if (n.lastPathTime <= n.pathDelay) {
    n.lastPathTime += e.value;
    return;
  }
  const u = (c = n.pathGenerator) == null ? void 0 : c.generate(n, e);
  (u && n.velocity.addTo(u),
    o.clamp &&
      ((n.velocity.x = Yt(n.velocity.x, -un, un)),
      (n.velocity.y = Yt(n.velocity.y, -un, un))),
    (n.lastPathTime -= n.pathDelay));
}
function bm(n) {
  return n.slow.inRange ? n.slow.factor : un;
}
function km(n) {
  const e = n.container,
    r = n.options,
    o = r.move.spin;
  if (!o.enable) return;
  const l = o.position ?? { x: 50, y: 50 },
    u = 0.01,
    c = { x: l.x * u * e.canvas.size.width, y: l.y * u * e.canvas.size.height },
    d = n.getPosition(),
    p = kt(d, c),
    m = H(o.acceleration);
  n.retina.spinAcceleration = m * e.retina.pixelRatio;
  const g = 0;
  n.spin = {
    center: c,
    direction: n.velocity.x >= g ? yt.clockwise : yt.counterClockwise,
    angle: n.velocity.angle,
    radius: p,
    acceleration: n.retina.spinAcceleration,
  };
}
const Sm = 2,
  Em = 1,
  Pm = 1;
class zm {
  init(e) {
    const r = e.options,
      o = r.move.gravity;
    ((e.gravity = {
      enable: o.enable,
      acceleration: H(o.acceleration),
      inverse: o.inverse,
    }),
      km(e));
  }
  isEnabled(e) {
    return !e.destroyed && e.options.move.enable;
  }
  move(e, r) {
    var _, E;
    const o = e.options,
      l = o.move;
    if (!l.enable) return;
    const u = e.container,
      c = u.retina.pixelRatio;
    ((_ = e.retina).moveSpeed ?? (_.moveSpeed = H(l.speed) * c),
      (E = e.retina).moveDrift ?? (E.moveDrift = H(e.options.move.drift) * c));
    const d = bm(e),
      p = e.retina.moveSpeed * u.retina.reduceFactor,
      m = e.retina.moveDrift,
      g = kn(o.size.value) * c,
      v = l.size ? e.getRadius() / g : Em,
      C = r.factor || Pm,
      x = (p * v * d * C) / Sm,
      b = e.retina.maxSpeed ?? u.retina.maxSpeed;
    (l.spin.enable ? xm(e, x) : wm(e, l, x, b, m, r), Cm(e));
  }
}
async function Om(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addMover("base", () => Promise.resolve(new zm()), e));
}
const Mm = 2,
  Rm = Math.PI * Mm,
  Dm = 0,
  Ah = { x: 0, y: 0 };
function Tm(n) {
  const { context: e, particle: r, radius: o } = n;
  r.circleRange || (r.circleRange = { min: Dm, max: Rm });
  const l = r.circleRange;
  e.arc(Ah.x, Ah.y, o, l.min, l.max, !1);
}
const Im = 12,
  Lm = 360,
  Nh = 0;
class Fm {
  constructor() {
    this.validTypes = ["circle"];
  }
  draw(e) {
    Tm(e);
  }
  getSidesCount() {
    return Im;
  }
  particleInit(e, r) {
    const o = r.shapeData,
      l = (o == null ? void 0 : o.angle) ?? { max: Lm, min: Nh };
    r.circleRange = Er(l)
      ? { min: $n(l.min), max: $n(l.max) }
      : { min: Nh, max: $n(l) };
  }
}
async function Am(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new Fm(), e));
}
class Nm {
  constructor(e, r) {
    ((this._container = e), (this._engine = r));
  }
  init(e) {
    const r = mi(
      this._engine,
      e.options.color,
      e.id,
      e.options.reduceDuplicates,
    );
    r &&
      (e.color = S1(
        r,
        e.options.color.animation,
        this._container.retina.reduceFactor,
      ));
  }
  isEnabled(e) {
    const { h: r, s: o, l } = e.options.color.animation,
      { color: u } = e;
    return (
      !e.destroyed &&
      !e.spawning &&
      (((u == null ? void 0 : u.h.value) !== void 0 && r.enable) ||
        ((u == null ? void 0 : u.s.value) !== void 0 && o.enable) ||
        ((u == null ? void 0 : u.l.value) !== void 0 && l.enable))
    );
  }
  update(e, r) {
    E1(e.color, r);
  }
}
async function $m(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater(
      "color",
      (r) => Promise.resolve(new Nm(r, n)),
      e,
    ));
}
var Ii;
(function (n) {
  ((n[(n.r = 1)] = "r"),
    (n[(n.g = 2)] = "g"),
    (n[(n.b = 3)] = "b"),
    (n[(n.a = 4)] = "a"));
})(Ii || (Ii = {}));
const jm = /^#?([a-f\d])([a-f\d])([a-f\d])([a-f\d])?$/i,
  Bm = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})?$/i,
  gl = 16,
  Um = 1,
  Hm = 255;
class Vm {
  constructor() {
    ((this.key = "hex"), (this.stringPrefix = "#"));
  }
  handleColor(e) {
    return this._parseString(e.value);
  }
  handleRangeColor(e) {
    return this._parseString(e.value);
  }
  parseString(e) {
    return this._parseString(e);
  }
  _parseString(e) {
    if (typeof e != "string" || !(e != null && e.startsWith(this.stringPrefix)))
      return;
    const r = e.replace(
        jm,
        (l, u, c, d, p) => u + u + c + c + d + d + (p !== void 0 ? p + p : ""),
      ),
      o = Bm.exec(r);
    return o
      ? {
          a: o[Ii.a] !== void 0 ? parseInt(o[Ii.a], gl) / Hm : Um,
          b: parseInt(o[Ii.b], gl),
          g: parseInt(o[Ii.g], gl),
          r: parseInt(o[Ii.r], gl),
        }
      : void 0;
  }
}
async function Wm(n, e = !0) {
  (re(n, "3.7.1"), await n.addColorManager(new Vm(), e));
}
var zr;
(function (n) {
  ((n[(n.h = 1)] = "h"),
    (n[(n.s = 2)] = "s"),
    (n[(n.l = 3)] = "l"),
    (n[(n.a = 5)] = "a"));
})(zr || (zr = {}));
class qm {
  constructor() {
    ((this.key = "hsl"), (this.stringPrefix = "hsl"));
  }
  handleColor(e) {
    const r = e.value,
      o = r.hsl ?? e.value;
    if (o.h !== void 0 && o.s !== void 0 && o.l !== void 0) return Br(o);
  }
  handleRangeColor(e) {
    const r = e.value,
      o = r.hsl ?? e.value;
    if (o.h !== void 0 && o.l !== void 0)
      return Br({ h: H(o.h), l: H(o.l), s: H(o.s) });
  }
  parseString(e) {
    if (!e.startsWith("hsl")) return;
    const r =
        /hsla?\(\s*(\d+)\s*[\s,]\s*(\d+)%\s*[\s,]\s*(\d+)%\s*([\s,]\s*(0|1|0?\.\d+|(\d{1,3})%)\s*)?\)/i,
      o = r.exec(e),
      l = 4,
      u = 1,
      c = 10;
    return o
      ? Gp({
          a: o.length > l ? d1(o[zr.a]) : u,
          h: parseInt(o[zr.h], c),
          l: parseInt(o[zr.l], c),
          s: parseInt(o[zr.s], c),
        })
      : void 0;
  }
}
async function Gm(n, e = !0) {
  (re(n, "3.7.1"), await n.addColorManager(new qm(), e));
}
class Qm {
  constructor(e) {
    this.container = e;
  }
  init(e) {
    const r = e.options.opacity,
      o = 1;
    e.opacity = v1(r, o);
    const l = r.animation;
    l.enable &&
      ((e.opacity.velocity =
        (H(l.speed) / at) * this.container.retina.reduceFactor),
      l.sync || (e.opacity.velocity *= se()));
  }
  isEnabled(e) {
    return (
      !e.destroyed &&
      !e.spawning &&
      !!e.opacity &&
      e.opacity.enable &&
      ((e.opacity.maxLoops ?? 0) <= 0 ||
        ((e.opacity.maxLoops ?? 0) > 0 &&
          (e.opacity.loops ?? 0) < (e.opacity.maxLoops ?? 0)))
    );
  }
  reset(e) {
    e.opacity && ((e.opacity.time = 0), (e.opacity.loops = 0));
  }
  update(e, r) {
    !this.isEnabled(e) ||
      !e.opacity ||
      la(e, e.opacity, !0, e.options.opacity.animation.destroy, r);
  }
}
async function Zm(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater(
      "opacity",
      (r) => Promise.resolve(new Qm(r)),
      e,
    ));
}
const Ql = 0,
  Ir = 0;
function Km(n) {
  if (
    (n.outMode !== Ze.bounce && n.outMode !== Ze.split) ||
    (n.direction !== me.left && n.direction !== me.right)
  )
    return;
  n.bounds.right < Ir && n.direction === me.left
    ? (n.particle.position.x = n.size + n.offset.x)
    : n.bounds.left > n.canvasSize.width &&
      n.direction === me.right &&
      (n.particle.position.x = n.canvasSize.width - n.size - n.offset.x);
  const e = n.particle.velocity.x;
  let r = !1;
  if (
    (n.direction === me.right &&
      n.bounds.right >= n.canvasSize.width &&
      e > Ql) ||
    (n.direction === me.left && n.bounds.left <= Ir && e < Ql)
  ) {
    const l = H(n.particle.options.bounce.horizontal.value);
    ((n.particle.velocity.x *= -l), (r = !0));
  }
  if (!r) return;
  const o = n.offset.x + n.size;
  (n.bounds.right >= n.canvasSize.width && n.direction === me.right
    ? (n.particle.position.x = n.canvasSize.width - o)
    : n.bounds.left <= Ir &&
      n.direction === me.left &&
      (n.particle.position.x = o),
    n.outMode === Ze.split && n.particle.destroy());
}
function Ym(n) {
  if (
    (n.outMode !== Ze.bounce && n.outMode !== Ze.split) ||
    (n.direction !== me.bottom && n.direction !== me.top)
  )
    return;
  n.bounds.bottom < Ir && n.direction === me.top
    ? (n.particle.position.y = n.size + n.offset.y)
    : n.bounds.top > n.canvasSize.height &&
      n.direction === me.bottom &&
      (n.particle.position.y = n.canvasSize.height - n.size - n.offset.y);
  const e = n.particle.velocity.y;
  let r = !1;
  if (
    (n.direction === me.bottom &&
      n.bounds.bottom >= n.canvasSize.height &&
      e > Ql) ||
    (n.direction === me.top && n.bounds.top <= Ir && e < Ql)
  ) {
    const l = H(n.particle.options.bounce.vertical.value);
    ((n.particle.velocity.y *= -l), (r = !0));
  }
  if (!r) return;
  const o = n.offset.y + n.size;
  (n.bounds.bottom >= n.canvasSize.height && n.direction === me.bottom
    ? (n.particle.position.y = n.canvasSize.height - o)
    : n.bounds.top <= Ir &&
      n.direction === me.top &&
      (n.particle.position.y = o),
    n.outMode === Ze.split && n.particle.destroy());
}
class Xm {
  constructor(e) {
    ((this.container = e), (this.modes = [Ze.bounce, Ze.split]));
  }
  update(e, r, o, l) {
    if (!this.modes.includes(l)) return;
    const u = this.container;
    let c = !1;
    for (const C of u.plugins.values())
      if ((C.particleBounce !== void 0 && (c = C.particleBounce(e, o, r)), c))
        break;
    if (c) return;
    const d = e.getPosition(),
      p = e.offset,
      m = e.getRadius(),
      g = Jo(d, m),
      v = u.canvas.size;
    (Km({
      particle: e,
      outMode: l,
      direction: r,
      bounds: g,
      canvasSize: v,
      offset: p,
      size: m,
    }),
      Ym({
        particle: e,
        outMode: l,
        direction: r,
        bounds: g,
        canvasSize: v,
        offset: p,
        size: m,
      }));
  }
}
const vl = 0;
class Jm {
  constructor(e) {
    ((this.container = e), (this.modes = [Ze.destroy]));
  }
  update(e, r, o, l) {
    if (!this.modes.includes(l)) return;
    const u = this.container;
    switch (e.outType) {
      case fn.normal:
      case fn.outside:
        if (Xo(e.position, u.canvas.size, ze.origin, e.getRadius(), r)) return;
        break;
      case fn.inside: {
        const { dx: c, dy: d } = Ct(e.position, e.moveCenter),
          { x: p, y: m } = e.velocity;
        if (
          (p < vl && c > e.moveCenter.radius) ||
          (m < vl && d > e.moveCenter.radius) ||
          (p >= vl && c < -e.moveCenter.radius) ||
          (m >= vl && d < -e.moveCenter.radius)
        )
          return;
        break;
      }
    }
    u.particles.remove(e, e.group, !0);
  }
}
const Cl = 0;
class ey {
  constructor(e) {
    ((this.container = e), (this.modes = [Ze.none]));
  }
  update(e, r, o, l) {
    if (
      !this.modes.includes(l) ||
      ((e.options.move.distance.horizontal &&
        (r === me.left || r === me.right)) ??
        (e.options.move.distance.vertical && (r === me.top || r === me.bottom)))
    )
      return;
    const u = e.options.move.gravity,
      c = this.container,
      d = c.canvas.size,
      p = e.getRadius();
    if (u.enable) {
      const m = e.position;
      ((!u.inverse && m.y > d.height + p && r === me.bottom) ||
        (u.inverse && m.y < -p && r === me.top)) &&
        c.particles.remove(e);
    } else {
      if (
        (e.velocity.y > Cl && e.position.y <= d.height + p) ||
        (e.velocity.y < Cl && e.position.y >= -p) ||
        (e.velocity.x > Cl && e.position.x <= d.width + p) ||
        (e.velocity.x < Cl && e.position.x >= -p)
      )
        return;
      Xo(e.position, c.canvas.size, ze.origin, p, r) || c.particles.remove(e);
    }
  }
}
const wl = 0,
  xl = 0;
class ty {
  constructor(e) {
    ((this.container = e), (this.modes = [Ze.out]));
  }
  update(e, r, o, l) {
    if (!this.modes.includes(l)) return;
    const u = this.container;
    switch (e.outType) {
      case fn.inside: {
        const { x: c, y: d } = e.velocity,
          p = ze.origin;
        ((p.length = e.moveCenter.radius),
          (p.angle = e.velocity.angle + Math.PI),
          p.addTo(ze.create(e.moveCenter)));
        const { dx: m, dy: g } = Ct(e.position, p);
        if (
          (c <= wl && m >= xl) ||
          (d <= wl && g >= xl) ||
          (c >= wl && m <= xl) ||
          (d >= wl && g <= xl)
        )
          return;
        ((e.position.x = Math.floor(ut({ min: 0, max: u.canvas.size.width }))),
          (e.position.y = Math.floor(
            ut({ min: 0, max: u.canvas.size.height }),
          )));
        const { dx: v, dy: C } = Ct(e.position, e.moveCenter);
        ((e.direction = Math.atan2(-C, -v)), (e.velocity.angle = e.direction));
        break;
      }
      default: {
        if (Xo(e.position, u.canvas.size, ze.origin, e.getRadius(), r)) return;
        switch (e.outType) {
          case fn.outside: {
            ((e.position.x =
              Math.floor(
                ut({ min: -e.moveCenter.radius, max: e.moveCenter.radius }),
              ) + e.moveCenter.x),
              (e.position.y =
                Math.floor(
                  ut({ min: -e.moveCenter.radius, max: e.moveCenter.radius }),
                ) + e.moveCenter.y));
            const { dx: c, dy: d } = Ct(e.position, e.moveCenter);
            e.moveCenter.radius &&
              ((e.direction = Math.atan2(d, c)),
              (e.velocity.angle = e.direction));
            break;
          }
          case fn.normal: {
            const c = e.options.move.warp,
              d = u.canvas.size,
              p = {
                bottom: d.height + e.getRadius() + e.offset.y,
                left: -e.getRadius() - e.offset.x,
                right: d.width + e.getRadius() + e.offset.x,
                top: -e.getRadius() - e.offset.y,
              },
              m = e.getRadius(),
              g = Jo(e.position, m);
            (r === me.right && g.left > d.width + e.offset.x
              ? ((e.position.x = p.left),
                (e.initialPosition.x = e.position.x),
                c ||
                  ((e.position.y = se() * d.height),
                  (e.initialPosition.y = e.position.y)))
              : r === me.left &&
                g.right < -e.offset.x &&
                ((e.position.x = p.right),
                (e.initialPosition.x = e.position.x),
                c ||
                  ((e.position.y = se() * d.height),
                  (e.initialPosition.y = e.position.y))),
              r === me.bottom && g.top > d.height + e.offset.y
                ? (c ||
                    ((e.position.x = se() * d.width),
                    (e.initialPosition.x = e.position.x)),
                  (e.position.y = p.top),
                  (e.initialPosition.y = e.position.y))
                : r === me.top &&
                  g.bottom < -e.offset.y &&
                  (c ||
                    ((e.position.x = se() * d.width),
                    (e.initialPosition.x = e.position.x)),
                  (e.position.y = p.bottom),
                  (e.initialPosition.y = e.position.y)));
            break;
          }
        }
        break;
      }
    }
  }
}
const ny = (n, e) =>
  n.default === e ||
  n.bottom === e ||
  n.left === e ||
  n.right === e ||
  n.top === e;
class iy {
  constructor(e) {
    ((this._addUpdaterIfMissing = (r, o, l) => {
      const u = r.options.move.outModes;
      !this.updaters.has(o) &&
        ny(u, o) &&
        this.updaters.set(o, l(this.container));
    }),
      (this._updateOutMode = (r, o, l, u) => {
        for (const c of this.updaters.values()) c.update(r, u, o, l);
      }),
      (this.container = e),
      (this.updaters = new Map()));
  }
  init(e) {
    (this._addUpdaterIfMissing(e, Ze.bounce, (r) => new Xm(r)),
      this._addUpdaterIfMissing(e, Ze.out, (r) => new ty(r)),
      this._addUpdaterIfMissing(e, Ze.destroy, (r) => new Jm(r)),
      this._addUpdaterIfMissing(e, Ze.none, (r) => new ey(r)));
  }
  isEnabled(e) {
    return !e.destroyed && !e.spawning;
  }
  update(e, r) {
    const o = e.options.move.outModes;
    (this._updateOutMode(e, r, o.bottom ?? o.default, me.bottom),
      this._updateOutMode(e, r, o.left ?? o.default, me.left),
      this._updateOutMode(e, r, o.right ?? o.default, me.right),
      this._updateOutMode(e, r, o.top ?? o.default, me.top));
  }
}
async function ry(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater(
      "outModes",
      (r) => Promise.resolve(new iy(r)),
      e,
    ));
}
var Or;
(function (n) {
  ((n[(n.r = 1)] = "r"),
    (n[(n.g = 2)] = "g"),
    (n[(n.b = 3)] = "b"),
    (n[(n.a = 5)] = "a"));
})(Or || (Or = {}));
class oy {
  constructor() {
    ((this.key = "rgb"), (this.stringPrefix = "rgb"));
  }
  handleColor(e) {
    const r = e.value,
      o = r.rgb ?? e.value;
    if (o.r !== void 0) return o;
  }
  handleRangeColor(e) {
    const r = e.value,
      o = r.rgb ?? e.value;
    if (o.r !== void 0) return { r: H(o.r), g: H(o.g), b: H(o.b) };
  }
  parseString(e) {
    if (!e.startsWith(this.stringPrefix)) return;
    const r =
        /rgba?\(\s*(\d{1,3})\s*[\s,]\s*(\d{1,3})\s*[\s,]\s*(\d{1,3})\s*([\s,]\s*(0|1|0?\.\d+|(\d{1,3})%)\s*)?\)/i,
      o = r.exec(e),
      l = 10;
    return o
      ? {
          a: o.length > 4 ? d1(o[Or.a]) : 1,
          b: parseInt(o[Or.b], l),
          g: parseInt(o[Or.g], l),
          r: parseInt(o[Or.r], l),
        }
      : void 0;
  }
}
async function sy(n, e = !0) {
  (re(n, "3.7.1"), await n.addColorManager(new oy(), e));
}
const Oi = 0;
class ly {
  init(e) {
    const r = e.container,
      o = e.options.size,
      l = o.animation;
    l.enable &&
      ((e.size.velocity =
        ((e.retina.sizeAnimationSpeed ?? r.retina.sizeAnimationSpeed) / at) *
        r.retina.reduceFactor),
      l.sync || (e.size.velocity *= se()));
  }
  isEnabled(e) {
    return (
      !e.destroyed &&
      !e.spawning &&
      e.size.enable &&
      ((e.size.maxLoops ?? Oi) <= Oi ||
        ((e.size.maxLoops ?? Oi) > Oi &&
          (e.size.loops ?? Oi) < (e.size.maxLoops ?? Oi)))
    );
  }
  reset(e) {
    e.size.loops = Oi;
  }
  update(e, r) {
    this.isEnabled(e) && la(e, e.size, !0, e.options.size.animation.destroy, r);
  }
}
async function ay(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater("size", () => Promise.resolve(new ly()), e));
}
async function uy(n, e = !0) {
  (re(n, "3.7.1"),
    await Wm(n, !1),
    await Gm(n, !1),
    await sy(n, !1),
    await Om(n, !1),
    await Am(n, !1),
    await $m(n, !1),
    await Zm(n, !1),
    await ry(n, !1),
    await ay(n, !1),
    await n.refresh(e));
}
async function cy(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addEasing(Ui.easeInQuad, (r) => r ** 2, !1),
    await n.addEasing(Ui.easeOutQuad, (r) => 1 - (1 - r) ** 2, !1),
    await n.addEasing(
      Ui.easeInOutQuad,
      (r) => (r < 0.5 ? 2 * r ** 2 : 1 - (-2 * r + 2) ** 2 / 2),
      !1,
    ),
    await n.refresh(e));
}
function fy(n, e) {
  const { context: r, opacity: o } = n,
    l = 0.5,
    u = r.globalAlpha;
  if (!e) return;
  const c = e.width,
    d = c * l;
  ((r.globalAlpha = o), r.drawImage(e, -d, -d, c, c), (r.globalAlpha = u));
}
const Pc =
    '"Twemoji Mozilla", Apple Color Emoji, "Segoe UI Emoji", "Noto Color Emoji", "EmojiOne Color"',
  $h = 0;
class dy {
  constructor() {
    ((this.validTypes = ["emoji"]), (this._emojiShapeDict = new Map()));
  }
  destroy() {
    for (const [e, r] of this._emojiShapeDict)
      (r instanceof ImageBitmap && (r == null || r.close()),
        this._emojiShapeDict.delete(e));
  }
  draw(e) {
    const r = e.particle.emojiDataKey;
    if (!r) return;
    const o = this._emojiShapeDict.get(r);
    o && fy(e, o);
  }
  async init(e) {
    const r = e.actualOptions,
      { validTypes: o } = this;
    if (!o.find((c) => Oe(c, r.particles.shape.type))) return;
    const l = [Yc(Pc)],
      u = o.map((c) => r.particles.shape.options[c]).find((c) => !!c);
    (u &&
      Ke(u, (c) => {
        c.font && l.push(Yc(c.font));
      }),
      await Promise.all(l));
  }
  particleDestroy(e) {
    e.emojiDataKey = void 0;
  }
  particleInit(e, r) {
    const l = r.shapeData;
    if (!(l != null && l.value)) return;
    const u = ct(l.value, r.randomIndexData);
    if (!u) return;
    const c =
        typeof u == "string"
          ? { font: l.font ?? Pc, padding: l.padding ?? $h, value: u }
          : { font: Pc, padding: $h, ...l, ...u },
      d = c.font,
      p = c.value,
      m = `${p}_${d}`;
    if (this._emojiShapeDict.has(m)) {
      r.emojiDataKey = m;
      return;
    }
    const g = c.padding * 2,
      v = kn(r.size.value),
      C = v + g,
      x = C * 2;
    let b;
    if (typeof OffscreenCanvas < "u") {
      const _ = new OffscreenCanvas(x, x),
        E = _.getContext("2d");
      if (!E) return;
      ((E.font = `400 ${v * 2}px ${d}`),
        (E.textBaseline = "middle"),
        (E.textAlign = "center"),
        E.fillText(p, C, C),
        (b = _.transferToImageBitmap()));
    } else {
      const _ = document.createElement("canvas");
      ((_.width = x), (_.height = x));
      const E = _.getContext("2d");
      if (!E) return;
      ((E.font = `400 ${v * 2}px ${d}`),
        (E.textBaseline = "middle"),
        (E.textAlign = "center"),
        E.fillText(p, C, C),
        (b = _));
    }
    (this._emojiShapeDict.set(m, b), (r.emojiDataKey = m));
  }
}
async function hy(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new dy(), e));
}
const py = 1,
  my = 1,
  F1 = 0;
function A1(n, e, r, o, l, u) {
  const c = e.actualOptions.interactivity.modes.attract;
  if (!c) return;
  const d = e.particles.quadTree.query(l, u);
  for (const p of d) {
    const { dx: m, dy: g, distance: v } = Ct(p.position, r),
      C = c.speed * c.factor,
      x = Yt(n.getEasing(c.easing)(my - v / o) * C, py, c.maxSpeed),
      b = ze.create(v ? (m / v) * x : C, v ? (g / v) * x : C);
    p.position.subFrom(b);
  }
}
function yy(n, e, r) {
  e.attract || (e.attract = { particles: [] });
  const { attract: o } = e;
  if (
    (o.finish ||
      (o.count || (o.count = 0),
      o.count++,
      o.count === e.particles.count && (o.finish = !0)),
    o.clicking)
  ) {
    const l = e.interactivity.mouse.clickPosition,
      u = e.retina.attractModeDistance;
    if (!u || u < F1 || !l) return;
    A1(n, e, l, u, new wt(l.x, l.y, u), (c) => r(c));
  } else o.clicking === !1 && (o.particles = []);
}
function gy(n, e, r) {
  const o = e.interactivity.mouse.position,
    l = e.retina.attractModeDistance;
  !l || l < F1 || !o || A1(n, e, o, l, new wt(o.x, o.y, l), (u) => r(u));
}
class vy {
  constructor() {
    ((this.distance = 200),
      (this.duration = 0.4),
      (this.easing = Ui.easeOutQuad),
      (this.factor = 1),
      (this.maxSpeed = 50),
      (this.speed = 1));
  }
  load(e) {
    $(e) ||
      (e.distance !== void 0 && (this.distance = e.distance),
      e.duration !== void 0 && (this.duration = e.duration),
      e.easing !== void 0 && (this.easing = e.easing),
      e.factor !== void 0 && (this.factor = e.factor),
      e.maxSpeed !== void 0 && (this.maxSpeed = e.maxSpeed),
      e.speed !== void 0 && (this.speed = e.speed));
  }
}
const $o = "attract";
let Cy = class extends pn {
  constructor(e, r) {
    (super(r),
      (this._engine = e),
      r.attract || (r.attract = { particles: [] }),
      (this.handleClickMode = (o) => {
        const l = this.container.actualOptions,
          u = l.interactivity.modes.attract;
        if (!(!u || o !== $o)) {
          (r.attract || (r.attract = { particles: [] }),
            (r.attract.clicking = !0),
            (r.attract.count = 0));
          for (const c of r.attract.particles)
            this.isEnabled(c) && c.velocity.setTo(c.initialVelocity);
          ((r.attract.particles = []),
            (r.attract.finish = !1),
            setTimeout(() => {
              r.destroyed ||
                (r.attract || (r.attract = { particles: [] }),
                (r.attract.clicking = !1));
            }, u.duration * Fe));
        }
      }));
  }
  clear() {}
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.attract;
    r && (e.retina.attractModeDistance = r.distance * e.retina.pixelRatio);
  }
  interact() {
    const e = this.container,
      r = e.actualOptions,
      o = e.interactivity.status === Wi,
      l = r.interactivity.events,
      { enable: u, mode: c } = l.onHover,
      { enable: d, mode: p } = l.onClick;
    o && u && Oe($o, c)
      ? gy(this._engine, this.container, (m) => this.isEnabled(m))
      : d &&
        Oe($o, p) &&
        yy(this._engine, this.container, (m) => this.isEnabled(m));
  }
  isEnabled(e) {
    const r = this.container,
      o = r.actualOptions,
      l = r.interactivity.mouse,
      u = ((e == null ? void 0 : e.interactivity) ?? o.interactivity).events;
    if (
      (!l.position || !u.onHover.enable) &&
      (!l.clickPosition || !u.onClick.enable)
    )
      return !1;
    const c = u.onHover.mode,
      d = u.onClick.mode;
    return Oe($o, c) || Oe($o, d);
  }
  loadModeOptions(e, ...r) {
    e.attract || (e.attract = new vy());
    for (const o of r) e.attract.load(o == null ? void 0 : o.attract);
  }
  reset() {}
};
async function wy(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalAttract",
      (r) => Promise.resolve(new Cy(n, r)),
      e,
    ));
}
const xy = 2,
  Dl = 0.5,
  _y = Math.PI * Dl,
  jh = 2,
  N1 = 10,
  by = 0;
function $1(n, e, r, o, l) {
  const u = n.particles.quadTree.query(o, l);
  for (const c of u)
    o instanceof wt
      ? y1(Xc(c), {
          position: e,
          radius: r,
          mass: r ** xy * _y,
          velocity: ze.origin,
          factor: ze.origin,
        })
      : o instanceof dn && Hp(c, Jo(e, r));
}
function ky(n, e, r, o) {
  const l = document.querySelectorAll(e);
  l.length &&
    l.forEach((u) => {
      const c = u,
        d = n.retina.pixelRatio,
        p = {
          x: (c.offsetLeft + c.offsetWidth * Dl) * d,
          y: (c.offsetTop + c.offsetHeight * Dl) * d,
        },
        m = c.offsetWidth * Dl * d,
        g = N1 * d,
        v =
          r.type === Vr.circle
            ? new wt(p.x, p.y, m + g)
            : new dn(
                c.offsetLeft * d - g,
                c.offsetTop * d - g,
                c.offsetWidth * d + g * jh,
                c.offsetHeight * d + g * jh,
              );
      o(p, m, v);
    });
}
function Sy(n, e, r, o) {
  y3(r, e, (l, u) => ky(n, l, u, (c, d, p) => $1(n, c, d, p, o)));
}
function Ey(n, e) {
  const r = n.retina.pixelRatio,
    o = N1 * r,
    l = n.interactivity.mouse.position,
    u = n.retina.bounceModeDistance;
  !u || u < by || !l || $1(n, l, u, new wt(l.x, l.y, u + o), e);
}
class Py {
  constructor() {
    this.distance = 200;
  }
  load(e) {
    $(e) || (e.distance !== void 0 && (this.distance = e.distance));
  }
}
const _l = "bounce";
class zy extends pn {
  constructor(e) {
    super(e);
  }
  clear() {}
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.bounce;
    r && (e.retina.bounceModeDistance = r.distance * e.retina.pixelRatio);
  }
  interact() {
    const e = this.container,
      r = e.actualOptions,
      o = r.interactivity.events,
      l = e.interactivity.status === Wi,
      u = o.onHover.enable,
      c = o.onHover.mode,
      d = o.onDiv;
    l && u && Oe(_l, c)
      ? Ey(this.container, (p) => this.isEnabled(p))
      : Sy(this.container, d, _l, (p) => this.isEnabled(p));
  }
  isEnabled(e) {
    const r = this.container,
      o = r.actualOptions,
      l = r.interactivity.mouse,
      u = ((e == null ? void 0 : e.interactivity) ?? o.interactivity).events,
      c = u.onDiv;
    return (
      (!!l.position && u.onHover.enable && Oe(_l, u.onHover.mode)) || m3(_l, c)
    );
  }
  loadModeOptions(e, ...r) {
    e.bounce || (e.bounce = new Py());
    for (const o of r) e.bounce.load(o == null ? void 0 : o.bounce);
  }
  reset() {}
}
async function Oy(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalBounce",
      (r) => Promise.resolve(new zy(r)),
      e,
    ));
}
class j1 {
  constructor() {
    ((this.distance = 200), (this.duration = 0.4), (this.mix = !1));
  }
  load(e) {
    if (!$(e)) {
      if (
        (e.distance !== void 0 && (this.distance = e.distance),
        e.duration !== void 0 && (this.duration = e.duration),
        e.mix !== void 0 && (this.mix = e.mix),
        e.opacity !== void 0 && (this.opacity = e.opacity),
        e.color !== void 0)
      ) {
        const r = vt(this.color) ? void 0 : this.color;
        this.color = Ke(e.color, (o) => Ve.create(r, o));
      }
      e.size !== void 0 && (this.size = e.size);
    }
  }
}
class My extends j1 {
  constructor() {
    (super(), (this.selectors = []));
  }
  load(e) {
    (super.load(e),
      !$(e) && e.selectors !== void 0 && (this.selectors = e.selectors));
  }
}
class Ry extends j1 {
  load(e) {
    (super.load(e),
      !$(e) &&
        (this.divs = Ke(e.divs, (r) => {
          const o = new My();
          return (o.load(r), o);
        })));
  }
}
var wn;
(function (n) {
  ((n.color = "color"), (n.opacity = "opacity"), (n.size = "size"));
})(wn || (wn = {}));
function Bh(n, e, r, o) {
  if (e >= r) {
    const l = n + (e - r) * o;
    return Yt(l, n, e);
  } else if (e < r) {
    const l = n - (r - e) * o;
    return Yt(l, e, n);
  }
}
const Mi = "bubble",
  zc = 0,
  Dy = 0,
  Ty = 2,
  Uh = 1,
  Hh = 1,
  Iy = 0,
  Ly = 0,
  Oc = 0.5,
  Mc = 1;
class Fy extends pn {
  constructor(e, r) {
    (super(e),
      (this._clickBubble = () => {
        var g;
        const o = this.container,
          l = o.actualOptions,
          u = o.interactivity.mouse.clickPosition,
          c = l.interactivity.modes.bubble;
        if (!c || !u) return;
        o.bubble || (o.bubble = {});
        const d = o.retina.bubbleModeDistance;
        if (!d || d < zc) return;
        const p = o.particles.quadTree.queryCircle(u, d, (v) =>
            this.isEnabled(v),
          ),
          { bubble: m } = o;
        for (const v of p) {
          if (!m.clicking) continue;
          v.bubble.inRange = !m.durationEnd;
          const C = v.getPosition(),
            x = kt(C, u),
            b =
              (new Date().getTime() - (o.interactivity.mouse.clickTime ?? Dy)) /
              Fe;
          (b > c.duration && (m.durationEnd = !0),
            b > c.duration * Ty && ((m.clicking = !1), (m.durationEnd = !1)));
          const _ = {
            bubbleObj: {
              optValue: o.retina.bubbleModeSize,
              value: v.bubble.radius,
            },
            particlesObj: {
              optValue: kn(v.options.size.value) * o.retina.pixelRatio,
              value: v.size.value,
            },
            type: wn.size,
          };
          this._process(v, x, b, _);
          const E = {
            bubbleObj: { optValue: c.opacity, value: v.bubble.opacity },
            particlesObj: {
              optValue: kn(v.options.opacity.value),
              value: ((g = v.opacity) == null ? void 0 : g.value) ?? Uh,
            },
            type: wn.opacity,
          };
          (this._process(v, x, b, E),
            !m.durationEnd && x <= d
              ? this._hoverBubbleColor(v, x)
              : delete v.bubble.color);
        }
      }),
      (this._hoverBubble = () => {
        const o = this.container,
          l = o.interactivity.mouse.position,
          u = o.retina.bubbleModeDistance;
        if (!u || u < zc || !l) return;
        const c = o.particles.quadTree.queryCircle(l, u, (d) =>
          this.isEnabled(d),
        );
        for (const d of c) {
          d.bubble.inRange = !0;
          const p = d.getPosition(),
            m = kt(p, l),
            g = Hh - m / u;
          (m <= u
            ? g >= Ly &&
              o.interactivity.status === Wi &&
              (this._hoverBubbleSize(d, g),
              this._hoverBubbleOpacity(d, g),
              this._hoverBubbleColor(d, g))
            : this.reset(d),
            o.interactivity.status === Kc && this.reset(d));
        }
      }),
      (this._hoverBubbleColor = (o, l, u) => {
        const c = this.container.actualOptions,
          d = u ?? c.interactivity.modes.bubble;
        if (d) {
          if (!o.bubble.finalColor) {
            const p = d.color;
            if (!p) return;
            const m = ct(p);
            o.bubble.finalColor = mi(this._engine, m);
          }
          if (o.bubble.finalColor)
            if (d.mix) {
              o.bubble.color = void 0;
              const p = o.getFillColor();
              o.bubble.color = p
                ? _1(g3(p, o.bubble.finalColor, Hh - l, l))
                : o.bubble.finalColor;
            } else o.bubble.color = o.bubble.finalColor;
        }
      }),
      (this._hoverBubbleOpacity = (o, l, u) => {
        var C, x;
        const c = this.container,
          d = c.actualOptions,
          p =
            (u == null ? void 0 : u.opacity) ??
            ((C = d.interactivity.modes.bubble) == null ? void 0 : C.opacity);
        if (!p) return;
        const m = o.options.opacity.value,
          g = ((x = o.opacity) == null ? void 0 : x.value) ?? Uh,
          v = Bh(g, p, kn(m), l);
        v !== void 0 && (o.bubble.opacity = v);
      }),
      (this._hoverBubbleSize = (o, l, u) => {
        const c = this.container,
          d =
            u != null && u.size
              ? u.size * c.retina.pixelRatio
              : c.retina.bubbleModeSize;
        if (d === void 0) return;
        const p = kn(o.options.size.value) * c.retina.pixelRatio,
          m = o.size.value,
          g = Bh(m, d, p, l);
        g !== void 0 && (o.bubble.radius = g);
      }),
      (this._process = (o, l, u, c) => {
        const d = this.container,
          p = c.bubbleObj.optValue,
          m = d.actualOptions,
          g = m.interactivity.modes.bubble;
        if (!g || p === void 0) return;
        const v = g.duration,
          C = d.retina.bubbleModeDistance,
          x = c.particlesObj.optValue,
          b = c.bubbleObj.value,
          _ = c.particlesObj.value ?? Iy,
          E = c.type;
        if (!(!C || C < zc || p === x))
          if ((d.bubble || (d.bubble = {}), d.bubble.durationEnd))
            b &&
              (E === wn.size && delete o.bubble.radius,
              E === wn.opacity && delete o.bubble.opacity);
          else if (l <= C) {
            if ((b ?? _) !== p) {
              const D = _ - (u * (_ - p)) / v;
              (E === wn.size && (o.bubble.radius = D),
                E === wn.opacity && (o.bubble.opacity = D));
            }
          } else
            (E === wn.size && delete o.bubble.radius,
              E === wn.opacity && delete o.bubble.opacity);
      }),
      (this._singleSelectorHover = (o, l, u) => {
        const c = this.container,
          d = document.querySelectorAll(l),
          p = c.actualOptions.interactivity.modes.bubble;
        !p ||
          !d.length ||
          d.forEach((m) => {
            const g = m,
              v = c.retina.pixelRatio,
              C = {
                x: (g.offsetLeft + g.offsetWidth * Oc) * v,
                y: (g.offsetTop + g.offsetHeight * Oc) * v,
              },
              x = g.offsetWidth * Oc * v,
              b =
                u.type === Vr.circle
                  ? new wt(C.x, C.y, x)
                  : new dn(
                      g.offsetLeft * v,
                      g.offsetTop * v,
                      g.offsetWidth * v,
                      g.offsetHeight * v,
                    ),
              _ = c.particles.quadTree.query(b, (E) => this.isEnabled(E));
            for (const E of _) {
              if (!b.contains(E.getPosition())) continue;
              E.bubble.inRange = !0;
              const T = p.divs,
                D = m1(T, g);
              ((!E.bubble.div || E.bubble.div !== g) &&
                (this.clear(E, o, !0), (E.bubble.div = g)),
                this._hoverBubbleSize(E, Mc, D),
                this._hoverBubbleOpacity(E, Mc, D),
                this._hoverBubbleColor(E, Mc, D));
            }
          });
      }),
      (this._engine = r),
      e.bubble || (e.bubble = {}),
      (this.handleClickMode = (o) => {
        o === Mi && (e.bubble || (e.bubble = {}), (e.bubble.clicking = !0));
      }));
  }
  clear(e, r, o) {
    (e.bubble.inRange && !o) ||
      (delete e.bubble.div,
      delete e.bubble.opacity,
      delete e.bubble.radius,
      delete e.bubble.color);
  }
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.bubble;
    r &&
      ((e.retina.bubbleModeDistance = r.distance * e.retina.pixelRatio),
      r.size !== void 0 &&
        (e.retina.bubbleModeSize = r.size * e.retina.pixelRatio));
  }
  interact(e) {
    const r = this.container.actualOptions,
      o = r.interactivity.events,
      l = o.onHover,
      u = o.onClick,
      c = l.enable,
      d = l.mode,
      p = u.enable,
      m = u.mode,
      g = o.onDiv;
    c && Oe(Mi, d)
      ? this._hoverBubble()
      : p && Oe(Mi, m)
        ? this._clickBubble()
        : y3(Mi, g, (v, C) => this._singleSelectorHover(e, v, C));
  }
  isEnabled(e) {
    const r = this.container,
      o = r.actualOptions,
      l = r.interactivity.mouse,
      u = ((e == null ? void 0 : e.interactivity) ?? o.interactivity).events,
      { onClick: c, onDiv: d, onHover: p } = u,
      m = m3(Mi, d);
    return m || (p.enable && l.position) || (c.enable && l.clickPosition)
      ? Oe(Mi, p.mode) || Oe(Mi, c.mode) || m
      : !1;
  }
  loadModeOptions(e, ...r) {
    e.bubble || (e.bubble = new Ry());
    for (const o of r) e.bubble.load(o == null ? void 0 : o.bubble);
  }
  reset(e) {
    e.bubble.inRange = !1;
  }
}
async function Ay(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalBubble",
      (r) => Promise.resolve(new Fy(r, n)),
      e,
    ));
}
class Ny {
  constructor() {
    this.opacity = 0.5;
  }
  load(e) {
    $(e) || (e.opacity !== void 0 && (this.opacity = e.opacity));
  }
}
class $y {
  constructor() {
    ((this.distance = 80), (this.links = new Ny()), (this.radius = 60));
  }
  load(e) {
    $(e) ||
      (e.distance !== void 0 && (this.distance = e.distance),
      this.links.load(e.links),
      e.radius !== void 0 && (this.radius = e.radius));
  }
}
const Vh = 0,
  Wh = 1,
  jy = 0;
function By(n, e, r, o) {
  const l = Math.floor(r.getRadius() / e.getRadius()),
    u = e.getFillColor(),
    c = r.getFillColor();
  if (!u || !c) return;
  const d = e.getPosition(),
    p = r.getPosition(),
    m = g3(u, c, e.getRadius(), r.getRadius()),
    g = n.createLinearGradient(d.x, d.y, p.x, p.y);
  return (
    g.addColorStop(Vh, Ur(u, o)),
    g.addColorStop(Yt(l, Vh, Wh), Sn(m, o)),
    g.addColorStop(Wh, Ur(c, o)),
    g
  );
}
function Uy(n, e, r, o, l) {
  (Vo(n, o, l), (n.lineWidth = e), (n.strokeStyle = r), n.stroke());
}
function Hy(n, e, r, o) {
  const l = n.actualOptions,
    u = l.interactivity.modes.connect;
  if (u) return By(e, r, o, u.links.opacity);
}
function Vy(n, e, r) {
  n.canvas.draw((o) => {
    const l = Hy(n, o, e, r);
    if (!l) return;
    const u = e.getPosition(),
      c = r.getPosition();
    Uy(o, e.retina.linksWidth ?? jy, l, u, c);
  });
}
const Wy = "connect",
  qh = 0;
class qy extends pn {
  constructor(e) {
    super(e);
  }
  clear() {}
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.connect;
    r &&
      ((e.retina.connectModeDistance = r.distance * e.retina.pixelRatio),
      (e.retina.connectModeRadius = r.radius * e.retina.pixelRatio));
  }
  interact() {
    const e = this.container;
    if (
      e.actualOptions.interactivity.events.onHover.enable &&
      e.interactivity.status === "pointermove"
    ) {
      const o = e.interactivity.mouse.position,
        { connectModeDistance: l, connectModeRadius: u } = e.retina;
      if (!l || l < qh || !u || u < qh || !o) return;
      const c = Math.abs(u),
        d = e.particles.quadTree.queryCircle(o, c, (p) => this.isEnabled(p));
      d.forEach((p, m) => {
        const g = p.getPosition(),
          v = 1;
        for (const C of d.slice(m + v)) {
          const x = C.getPosition(),
            b = Math.abs(l),
            _ = Math.abs(g.x - x.x),
            E = Math.abs(g.y - x.y);
          _ < b && E < b && Vy(e, p, C);
        }
      });
    }
  }
  isEnabled(e) {
    const r = this.container,
      o = r.interactivity.mouse,
      l = (
        (e == null ? void 0 : e.interactivity) ?? r.actualOptions.interactivity
      ).events;
    return l.onHover.enable && o.position ? Oe(Wy, l.onHover.mode) : !1;
  }
  loadModeOptions(e, ...r) {
    e.connect || (e.connect = new $y());
    for (const o of r) e.connect.load(o == null ? void 0 : o.connect);
  }
  reset() {}
}
async function Gy(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalConnect",
      (r) => Promise.resolve(new qy(r)),
      e,
    ));
}
class Qy {
  constructor() {
    ((this.blink = !1), (this.consent = !1), (this.opacity = 1));
  }
  load(e) {
    $(e) ||
      (e.blink !== void 0 && (this.blink = e.blink),
      e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.consent !== void 0 && (this.consent = e.consent),
      e.opacity !== void 0 && (this.opacity = e.opacity));
  }
}
class Zy {
  constructor() {
    ((this.distance = 100), (this.links = new Qy()));
  }
  load(e) {
    $(e) ||
      (e.distance !== void 0 && (this.distance = e.distance),
      this.links.load(e.links));
  }
}
const Ky = 0;
function Yy(n, e, r, o, l, u) {
  (Vo(n, r, o), (n.strokeStyle = Sn(l, u)), (n.lineWidth = e), n.stroke());
}
function Xy(n, e, r, o, l) {
  n.canvas.draw((u) => {
    const c = e.getPosition();
    Yy(u, e.retina.linksWidth ?? Ky, c, l, r, o);
  });
}
const Jy = "grab",
  eg = 0,
  tg = 0;
class ng extends pn {
  constructor(e, r) {
    (super(e), (this._engine = r));
  }
  clear() {}
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.grab;
    r && (e.retina.grabModeDistance = r.distance * e.retina.pixelRatio);
  }
  interact() {
    var d;
    const e = this.container,
      r = e.actualOptions,
      o = r.interactivity;
    if (
      !o.modes.grab ||
      !o.events.onHover.enable ||
      e.interactivity.status !== Wi
    )
      return;
    const l = e.interactivity.mouse.position;
    if (!l) return;
    const u = e.retina.grabModeDistance;
    if (!u || u < eg) return;
    const c = e.particles.quadTree.queryCircle(l, u, (p) => this.isEnabled(p));
    for (const p of c) {
      const m = p.getPosition(),
        g = kt(m, l);
      if (g > u) continue;
      const v = o.modes.grab.links,
        C = v.opacity,
        x = C - (g * C) / u;
      if (x <= tg) continue;
      const b = v.color ?? ((d = p.options.links) == null ? void 0 : d.color);
      if (!e.particles.grabLineColor && b) {
        const E = o.modes.grab.links;
        e.particles.grabLineColor = k1(this._engine, b, E.blink, E.consent);
      }
      const _ = Jc(p, void 0, e.particles.grabLineColor);
      _ && Xy(e, p, _, x, l);
    }
  }
  isEnabled(e) {
    const r = this.container,
      o = r.interactivity.mouse,
      l = (
        (e == null ? void 0 : e.interactivity) ?? r.actualOptions.interactivity
      ).events;
    return l.onHover.enable && !!o.position && Oe(Jy, l.onHover.mode);
  }
  loadModeOptions(e, ...r) {
    e.grab || (e.grab = new Zy());
    for (const o of r) e.grab.load(o == null ? void 0 : o.grab);
  }
  reset() {}
}
async function ig(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalGrab",
      (r) => Promise.resolve(new ng(r, n)),
      e,
    ));
}
const rg = "pause";
class og extends pn {
  constructor(e) {
    (super(e),
      (this.handleClickMode = (r) => {
        if (r !== rg) return;
        const o = this.container;
        o.animationStatus ? o.pause() : o.play();
      }));
  }
  clear() {}
  init() {}
  interact() {}
  isEnabled() {
    return !0;
  }
  reset() {}
}
async function sg(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalPause",
      (r) => Promise.resolve(new og(r)),
      e,
    ));
}
class lg {
  constructor() {
    ((this.default = !0), (this.groups = []), (this.quantity = 4));
  }
  load(e) {
    if ($(e)) return;
    (e.default !== void 0 && (this.default = e.default),
      e.groups !== void 0 && (this.groups = e.groups.map((o) => o)),
      this.groups.length || (this.default = !0));
    const r = e.quantity;
    r !== void 0 && (this.quantity = ee(r));
  }
}
const ag = "push",
  ug = 0;
class cg extends pn {
  constructor(e) {
    (super(e),
      (this.handleClickMode = (r) => {
        if (r !== ag) return;
        const o = this.container,
          l = o.actualOptions,
          u = l.interactivity.modes.push;
        if (!u) return;
        const c = H(u.quantity);
        if (c <= ug) return;
        const d = Yo([void 0, ...u.groups]),
          p = d !== void 0 ? o.actualOptions.particles.groups[d] : void 0;
        o.particles.push(c, o.interactivity.mouse, p, d);
      }));
  }
  clear() {}
  init() {}
  interact() {}
  isEnabled() {
    return !0;
  }
  loadModeOptions(e, ...r) {
    e.push || (e.push = new lg());
    for (const o of r) e.push.load(o == null ? void 0 : o.push);
  }
  reset() {}
}
async function fg(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalPush",
      (r) => Promise.resolve(new cg(r)),
      e,
    ));
}
class dg {
  constructor() {
    this.quantity = 2;
  }
  load(e) {
    if ($(e)) return;
    const r = e.quantity;
    r !== void 0 && (this.quantity = ee(r));
  }
}
const hg = "remove";
class pg extends pn {
  constructor(e) {
    (super(e),
      (this.handleClickMode = (r) => {
        const o = this.container,
          l = o.actualOptions;
        if (!l.interactivity.modes.remove || r !== hg) return;
        const u = H(l.interactivity.modes.remove.quantity);
        o.particles.removeQuantity(u);
      }));
  }
  clear() {}
  init() {}
  interact() {}
  isEnabled() {
    return !0;
  }
  loadModeOptions(e, ...r) {
    e.remove || (e.remove = new dg());
    for (const o of r) e.remove.load(o == null ? void 0 : o.remove);
  }
  reset() {}
}
async function mg(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalRemove",
      (r) => Promise.resolve(new pg(r)),
      e,
    ));
}
class B1 {
  constructor() {
    ((this.distance = 200),
      (this.duration = 0.4),
      (this.factor = 100),
      (this.speed = 1),
      (this.maxSpeed = 50),
      (this.easing = Ui.easeOutQuad));
  }
  load(e) {
    $(e) ||
      (e.distance !== void 0 && (this.distance = e.distance),
      e.duration !== void 0 && (this.duration = e.duration),
      e.easing !== void 0 && (this.easing = e.easing),
      e.factor !== void 0 && (this.factor = e.factor),
      e.speed !== void 0 && (this.speed = e.speed),
      e.maxSpeed !== void 0 && (this.maxSpeed = e.maxSpeed));
  }
}
class yg extends B1 {
  constructor() {
    (super(), (this.selectors = []));
  }
  load(e) {
    (super.load(e),
      !$(e) && e.selectors !== void 0 && (this.selectors = e.selectors));
  }
}
class gg extends B1 {
  load(e) {
    (super.load(e),
      !$(e) &&
        (this.divs = Ke(e.divs, (r) => {
          const o = new yg();
          return (o.load(r), o);
        })));
  }
}
const Ri = "repulse",
  vg = 0,
  Cg = 6,
  wg = 3,
  xg = 2,
  _g = 0,
  bg = 0,
  kg = 1,
  Rc = 0.5;
class Sg extends pn {
  constructor(e, r) {
    (super(r),
      (this._clickRepulse = () => {
        const o = this.container,
          l = o.actualOptions.interactivity.modes.repulse;
        if (!l) return;
        const u = o.repulse ?? { particles: [] };
        if (
          (u.finish ||
            (u.count || (u.count = 0),
            u.count++,
            u.count === o.particles.count && (u.finish = !0)),
          u.clicking)
        ) {
          const c = o.retina.repulseModeDistance;
          if (!c || c < vg) return;
          const d = Math.pow(c / Cg, wg),
            p = o.interactivity.mouse.clickPosition;
          if (p === void 0) return;
          const m = new wt(p.x, p.y, d),
            g = o.particles.quadTree.query(m, (v) => this.isEnabled(v));
          for (const v of g) {
            const { dx: C, dy: x, distance: b } = Ct(p, v.position),
              _ = b ** xg,
              E = l.speed,
              T = (-d * E) / _;
            if (_ <= d) {
              u.particles.push(v);
              const D = ze.create(C, x);
              ((D.length = T), v.velocity.setTo(D));
            }
          }
        } else if (u.clicking === !1) {
          for (const c of u.particles) c.velocity.setTo(c.initialVelocity);
          u.particles = [];
        }
      }),
      (this._hoverRepulse = () => {
        const o = this.container,
          l = o.interactivity.mouse.position,
          u = o.retina.repulseModeDistance;
        !u || u < _g || !l || this._processRepulse(l, u, new wt(l.x, l.y, u));
      }),
      (this._processRepulse = (o, l, u, c) => {
        const d = this.container,
          p = d.particles.quadTree.query(u, (E) => this.isEnabled(E)),
          m = d.actualOptions.interactivity.modes.repulse;
        if (!m) return;
        const { easing: g, speed: v, factor: C, maxSpeed: x } = m,
          b = this._engine.getEasing(g),
          _ = ((c == null ? void 0 : c.speed) ?? v) * C;
        for (const E of p) {
          const { dx: T, dy: D, distance: I } = Ct(E.position, o),
            R = Yt(b(kg - I / l) * _, bg, x),
            N = ze.create(I ? (T / I) * R : _, I ? (D / I) * R : _);
          E.position.addTo(N);
        }
      }),
      (this._singleSelectorRepulse = (o, l) => {
        const u = this.container,
          c = u.actualOptions.interactivity.modes.repulse;
        if (!c) return;
        const d = document.querySelectorAll(o);
        d.length &&
          d.forEach((p) => {
            const m = p,
              g = u.retina.pixelRatio,
              v = {
                x: (m.offsetLeft + m.offsetWidth * Rc) * g,
                y: (m.offsetTop + m.offsetHeight * Rc) * g,
              },
              C = m.offsetWidth * Rc * g,
              x =
                l.type === Vr.circle
                  ? new wt(v.x, v.y, C)
                  : new dn(
                      m.offsetLeft * g,
                      m.offsetTop * g,
                      m.offsetWidth * g,
                      m.offsetHeight * g,
                    ),
              b = c.divs,
              _ = m1(b, m);
            this._processRepulse(v, C, x, _);
          });
      }),
      (this._engine = e),
      r.repulse || (r.repulse = { particles: [] }),
      (this.handleClickMode = (o) => {
        const l = this.container.actualOptions,
          u = l.interactivity.modes.repulse;
        if (!u || o !== Ri) return;
        r.repulse || (r.repulse = { particles: [] });
        const c = r.repulse;
        ((c.clicking = !0), (c.count = 0));
        for (const d of r.repulse.particles)
          this.isEnabled(d) && d.velocity.setTo(d.initialVelocity);
        ((c.particles = []),
          (c.finish = !1),
          setTimeout(() => {
            r.destroyed || (c.clicking = !1);
          }, u.duration * Fe));
      }));
  }
  clear() {}
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.repulse;
    r && (e.retina.repulseModeDistance = r.distance * e.retina.pixelRatio);
  }
  interact() {
    const e = this.container,
      r = e.actualOptions,
      o = e.interactivity.status === Wi,
      l = r.interactivity.events,
      u = l.onHover,
      c = u.enable,
      d = u.mode,
      p = l.onClick,
      m = p.enable,
      g = p.mode,
      v = l.onDiv;
    o && c && Oe(Ri, d)
      ? this._hoverRepulse()
      : m && Oe(Ri, g)
        ? this._clickRepulse()
        : y3(Ri, v, (C, x) => this._singleSelectorRepulse(C, x));
  }
  isEnabled(e) {
    const r = this.container,
      o = r.actualOptions,
      l = r.interactivity.mouse,
      u = ((e == null ? void 0 : e.interactivity) ?? o.interactivity).events,
      c = u.onDiv,
      d = u.onHover,
      p = u.onClick,
      m = m3(Ri, c);
    if (!(m || (d.enable && l.position) || (p.enable && l.clickPosition)))
      return !1;
    const g = d.mode,
      v = p.mode;
    return Oe(Ri, g) || Oe(Ri, v) || m;
  }
  loadModeOptions(e, ...r) {
    e.repulse || (e.repulse = new gg());
    for (const o of r) e.repulse.load(o == null ? void 0 : o.repulse);
  }
  reset() {}
}
async function Eg(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalRepulse",
      (r) => Promise.resolve(new Sg(n, r)),
      e,
    ));
}
class Pg {
  constructor() {
    ((this.factor = 3), (this.radius = 200));
  }
  load(e) {
    $(e) ||
      (e.factor !== void 0 && (this.factor = e.factor),
      e.radius !== void 0 && (this.radius = e.radius));
  }
}
const zg = "slow",
  Og = 0;
class Mg extends pn {
  constructor(e) {
    super(e);
  }
  clear(e, r, o) {
    (e.slow.inRange && !o) || (e.slow.factor = 1);
  }
  init() {
    const e = this.container,
      r = e.actualOptions.interactivity.modes.slow;
    r && (e.retina.slowModeRadius = r.radius * e.retina.pixelRatio);
  }
  interact() {}
  isEnabled(e) {
    const r = this.container,
      o = r.interactivity.mouse,
      l = (
        (e == null ? void 0 : e.interactivity) ?? r.actualOptions.interactivity
      ).events;
    return l.onHover.enable && !!o.position && Oe(zg, l.onHover.mode);
  }
  loadModeOptions(e, ...r) {
    e.slow || (e.slow = new Pg());
    for (const o of r) e.slow.load(o == null ? void 0 : o.slow);
  }
  reset(e) {
    e.slow.inRange = !1;
    const r = this.container,
      o = r.actualOptions,
      l = r.interactivity.mouse.position,
      u = r.retina.slowModeRadius,
      c = o.interactivity.modes.slow;
    if (!c || !u || u < Og || !l) return;
    const d = e.getPosition(),
      p = kt(l, d),
      m = p / u,
      g = c.factor,
      { slow: v } = e;
    p > u || ((v.inRange = !0), (v.factor = m / g));
  }
}
async function Rg(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "externalSlow",
      (r) => Promise.resolve(new Mg(r)),
      e,
    ));
}
const Dg = 0,
  Tg = 1,
  Ig =
    /(#(?:[0-9a-f]{2}){2,4}|(#[0-9a-f]{3})|(rgb|hsl)a?\((-?\d+%?[,\s]+){2,3}\s*[\d.]+%?\))|currentcolor/gi;
function Lg(n, e, r) {
  const { svgData: o } = n;
  if (!o) return "";
  const l = Ur(e, r);
  if (o.includes("fill")) return o.replace(Ig, () => l);
  const u = o.indexOf(">");
  return `${o.substring(Dg, u)} fill="${l}"${o.substring(u)}`;
}
async function aa(n) {
  return new Promise((e) => {
    n.loading = !0;
    const r = new Image();
    ((n.element = r),
      r.addEventListener("load", () => {
        ((n.loading = !1), e());
      }),
      r.addEventListener("error", () => {
        ((n.element = void 0),
          (n.error = !0),
          (n.loading = !1),
          Gi().error(`${Kt} loading image: ${n.source}`),
          e());
      }),
      (r.src = n.source));
  });
}
async function Fg(n) {
  if (n.type !== "svg") {
    await aa(n);
    return;
  }
  n.loading = !0;
  const e = await fetch(n.source);
  (e.ok
    ? (n.svgData = await e.text())
    : (Gi().error(`${Kt} Image not found`), (n.error = !0)),
    (n.loading = !1));
}
function Ag(n, e, r, o) {
  var c;
  const l = Lg(n, r, ((c = o.opacity) == null ? void 0 : c.value) ?? Tg),
    u = {
      color: r,
      gif: e.gif,
      data: { ...n, svgData: l },
      loaded: !1,
      ratio: e.width / e.height,
      replaceColor: e.replaceColor,
      source: e.src,
    };
  return new Promise((d) => {
    const p = new Blob([l], { type: "image/svg+xml" }),
      m = URL || window.URL || window.webkitURL || window,
      g = m.createObjectURL(p),
      v = new Image();
    v.addEventListener("load", () => {
      ((u.loaded = !0), (u.element = v), d(u), m.revokeObjectURL(g));
    });
    const C = async () => {
      m.revokeObjectURL(g);
      const x = { ...n, error: !1, loading: !0 };
      (await aa(x), (u.loaded = !0), (u.element = x.element), d(u));
    };
    (v.addEventListener("error", () => void C()), (v.src = g));
  });
}
const Dc = [0, 4, 2, 1],
  Gh = [8, 8, 4, 2];
class Ng {
  constructor(e) {
    ((this.pos = 0), (this.data = new Uint8ClampedArray(e)));
  }
  getString(e) {
    const r = this.data.slice(this.pos, this.pos + e);
    return (
      (this.pos += r.length),
      r.reduce((o, l) => o + String.fromCharCode(l), "")
    );
  }
  nextByte() {
    return this.data[this.pos++];
  }
  nextTwoBytes() {
    return (
      (this.pos += 2),
      this.data[this.pos - 2] + (this.data[this.pos - 1] << 8)
    );
  }
  readSubBlocks() {
    let e = "",
      r = 0;
    const o = 0,
      l = 0;
    do {
      r = this.data[this.pos++];
      for (
        let u = r;
        --u >= o;
        e += String.fromCharCode(this.data[this.pos++])
      );
    } while (r !== l);
    return e;
  }
  readSubBlocksBin() {
    let e = this.data[this.pos],
      r = 0;
    const o = 0,
      l = 1;
    for (let c = 0; e !== o; c += e + l, e = this.data[this.pos + c]) r += e;
    const u = new Uint8Array(r);
    e = this.data[this.pos++];
    for (let c = 0; e !== o; e = this.data[this.pos++])
      for (let d = e; --d >= o; u[c++] = this.data[this.pos++]);
    return u;
  }
  skipSubBlocks() {
    for (
      const e = 1, r = 0;
      this.data[this.pos] !== r;
      this.pos += this.data[this.pos] + e
    );
    this.pos++;
  }
}
var ln;
(function (n) {
  ((n[(n.Replace = 0)] = "Replace"),
    (n[(n.Combine = 1)] = "Combine"),
    (n[(n.RestoreBackground = 2)] = "RestoreBackground"),
    (n[(n.RestorePrevious = 3)] = "RestorePrevious"),
    (n[(n.UndefinedA = 4)] = "UndefinedA"),
    (n[(n.UndefinedB = 5)] = "UndefinedB"),
    (n[(n.UndefinedC = 6)] = "UndefinedC"),
    (n[(n.UndefinedD = 7)] = "UndefinedD"));
})(ln || (ln = {}));
var An;
(function (n) {
  ((n[(n.Extension = 33)] = "Extension"),
    (n[(n.ApplicationExtension = 255)] = "ApplicationExtension"),
    (n[(n.GraphicsControlExtension = 249)] = "GraphicsControlExtension"),
    (n[(n.PlainTextExtension = 1)] = "PlainTextExtension"),
    (n[(n.CommentExtension = 254)] = "CommentExtension"),
    (n[(n.Image = 44)] = "Image"),
    (n[(n.EndOfFile = 59)] = "EndOfFile"));
})(An || (An = {}));
const Rt = { x: 0, y: 0 },
  $g = 0,
  Qh = 0.5,
  jg = 0,
  Zh = 0,
  i3 = 0;
function U1(n, e) {
  const r = [];
  for (let o = 0; o < e; o++)
    (r.push({ r: n.data[n.pos], g: n.data[n.pos + 1], b: n.data[n.pos + 2] }),
      (n.pos += 3));
  return r;
}
function Bg(n, e, r, o) {
  switch (n.nextByte()) {
    case An.GraphicsControlExtension: {
      const l = e.frames[r(!1)];
      n.pos++;
      const u = n.nextByte();
      ((l.GCreserved = (u & 224) >>> 5),
        (l.disposalMethod = (u & 28) >>> 2),
        (l.userInputDelayFlag = (u & 2) === 2));
      const c = (u & 1) === 1;
      l.delayTime = n.nextTwoBytes() * 10;
      const d = n.nextByte();
      (c && o(d), n.pos++);
      break;
    }
    case An.ApplicationExtension: {
      n.pos++;
      const l = {
        identifier: n.getString(8),
        authenticationCode: n.getString(3),
        data: n.readSubBlocksBin(),
      };
      e.applicationExtensions.push(l);
      break;
    }
    case An.CommentExtension: {
      e.comments.push([r(!1), n.readSubBlocks()]);
      break;
    }
    case An.PlainTextExtension: {
      if (e.globalColorTable.length === 0)
        throw new EvalError("plain text extension without global color table");
      (n.pos++,
        (e.frames[r(!1)].plainTextData = {
          left: n.nextTwoBytes(),
          top: n.nextTwoBytes(),
          width: n.nextTwoBytes(),
          height: n.nextTwoBytes(),
          charSize: { width: n.nextTwoBytes(), height: n.nextTwoBytes() },
          foregroundColor: n.nextByte(),
          backgroundColor: n.nextByte(),
          text: n.readSubBlocks(),
        }));
      break;
    }
    default:
      n.skipSubBlocks();
      break;
  }
}
async function Ug(n, e, r, o, l, u) {
  const c = e.frames[o(!0)];
  ((c.left = n.nextTwoBytes()),
    (c.top = n.nextTwoBytes()),
    (c.width = n.nextTwoBytes()),
    (c.height = n.nextTwoBytes()));
  const d = n.nextByte(),
    p = (d & 128) === 128,
    m = (d & 64) === 64;
  ((c.sortFlag = (d & 32) === 32), (c.reserved = (d & 24) >>> 3));
  const g = 1 << ((d & 7) + 1);
  p && (c.localColorTable = U1(n, g));
  const v = (T) => {
      const {
        r: D,
        g: I,
        b: R,
      } = (p ? c.localColorTable : e.globalColorTable)[T];
      return T !== l(null)
        ? { r: D, g: I, b: R, a: 255 }
        : { r: D, g: I, b: R, a: r ? ~~((D + I + R) / 3) : 0 };
    },
    C = (() => {
      try {
        return new ImageData(c.width, c.height, { colorSpace: "srgb" });
      } catch (T) {
        if (T instanceof DOMException && T.name === "IndexSizeError")
          return null;
        throw T;
      }
    })();
  if (C == null) throw new EvalError("GIF frame size is to large");
  const x = n.nextByte(),
    b = n.readSubBlocksBin(),
    _ = 1 << x,
    E = (T, D) => {
      const I = T >>> 3,
        R = T & 7;
      return (
        ((b[I] + (b[I + 1] << 8) + (b[I + 2] << 16)) &
          (((1 << D) - 1) << R)) >>>
        R
      );
    };
  if (m) {
    for (let T = 0, D = x + 1, I = 0, R = [[0]], N = 0; N < 4; N++)
      if (Dc[N] < c.height) {
        let F = 0,
          V = 0,
          ie = !1;
        for (; !ie;) {
          const he = T;
          if (((T = E(I, D)), (I += D + 1), T === _)) {
            ((D = x + 1), (R.length = _ + 2));
            for (let _e = 0; _e < R.length; _e++) R[_e] = _e < _ ? [_e] : [];
          } else {
            T >= R.length
              ? R.push(R[he].concat(R[he][0]))
              : he !== _ && R.push(R[he].concat(R[T][0]));
            for (const _e of R[T]) {
              const { r: Se, g: We, b: Be, a: pe } = v(_e);
              (C.data.set(
                [Se, We, Be, pe],
                Dc[N] * c.width + Gh[N] * V + (F % (c.width * 4)),
              ),
                (F += 4));
            }
            R.length === 1 << D && D < 12 && D++;
          }
          F === c.width * 4 * (V + 1) &&
            (V++, Dc[N] + Gh[N] * V >= c.height && (ie = !0));
        }
      }
    ((c.image = C), (c.bitmap = await createImageBitmap(C)));
  } else {
    let T = 0,
      D = x + 1,
      I = 0,
      R = -4,
      N = !1;
    const F = [[0]];
    for (; !N;) {
      const V = T;
      if (((T = E(I, D)), (I += D), T === _)) {
        ((D = x + 1), (F.length = _ + 2));
        for (let ie = 0; ie < F.length; ie++) F[ie] = ie < _ ? [ie] : [];
      } else {
        if (T === _ + 1) {
          N = !0;
          break;
        }
        T >= F.length
          ? F.push(F[V].concat(F[V][0]))
          : V !== _ && F.push(F[V].concat(F[T][0]));
        for (const ie of F[T]) {
          const { r: he, g: _e, b: Se, a: We } = v(ie);
          C.data.set([he, _e, Se, We], (R += 4));
        }
        F.length >= 1 << D && D < 12 && D++;
      }
    }
    ((c.image = C), (c.bitmap = await createImageBitmap(C)));
  }
}
async function Hg(n, e, r, o, l, u) {
  switch (n.nextByte()) {
    case An.EndOfFile:
      return !0;
    case An.Image:
      await Ug(n, e, r, o, l);
      break;
    case An.Extension:
      Bg(n, e, o, l);
      break;
    default:
      throw new EvalError("undefined block found");
  }
  return !1;
}
function Vg(n) {
  for (const e of n.applicationExtensions)
    if (e.identifier + e.authenticationCode === "NETSCAPE2.0")
      return e.data[1] + (e.data[2] << 8);
  return NaN;
}
async function Wg(n, e, r) {
  r || (r = !1);
  const o = await fetch(n);
  if (!o.ok && o.status === 404) throw new EvalError("file not found");
  const l = await o.arrayBuffer(),
    u = {
      width: 0,
      height: 0,
      totalTime: 0,
      colorRes: 0,
      pixelAspectRatio: 0,
      frames: [],
      sortFlag: !1,
      globalColorTable: [],
      backgroundImage: new ImageData(1, 1, { colorSpace: "srgb" }),
      comments: [],
      applicationExtensions: [],
    },
    c = new Ng(new Uint8ClampedArray(l));
  if (c.getString(6) !== "GIF89a") throw new Error("not a supported GIF file");
  ((u.width = c.nextTwoBytes()), (u.height = c.nextTwoBytes()));
  const d = c.nextByte(),
    p = (d & 128) === 128;
  ((u.colorRes = (d & 112) >>> 4), (u.sortFlag = (d & 8) === 8));
  const m = 1 << ((d & 7) + 1),
    g = c.nextByte();
  ((u.pixelAspectRatio = c.nextByte()),
    u.pixelAspectRatio !== 0 &&
      (u.pixelAspectRatio = (u.pixelAspectRatio + 15) / 64),
    p && (u.globalColorTable = U1(c, m)));
  const v = (() => {
    try {
      return new ImageData(u.width, u.height, { colorSpace: "srgb" });
    } catch (R) {
      if (R instanceof DOMException && R.name === "IndexSizeError") return null;
      throw R;
    }
  })();
  if (v == null) throw new Error("GIF frame size is to large");
  const { r: C, g: x, b } = u.globalColorTable[g];
  v.data.set(p ? [C, x, b, 255] : [0, 0, 0, 0]);
  for (let R = 4; R < v.data.length; R *= 2) v.data.copyWithin(R, 0, R);
  u.backgroundImage = v;
  let _ = -1,
    E = !0,
    T = -1;
  const D = (R) => (R && (E = !0), _),
    I = (R) => (R != null && (T = R), T);
  try {
    do
      E &&
        (u.frames.push({
          left: 0,
          top: 0,
          width: 0,
          height: 0,
          disposalMethod: ln.Replace,
          image: new ImageData(1, 1, { colorSpace: "srgb" }),
          plainTextData: null,
          userInputDelayFlag: !1,
          delayTime: 0,
          sortFlag: !1,
          localColorTable: [],
          reserved: 0,
          GCreserved: 0,
        }),
        _++,
        (T = -1),
        (E = !1));
    while (!(await Hg(c, u, r, D, I, e)));
    u.frames.length--;
    for (const R of u.frames) {
      if (R.userInputDelayFlag && R.delayTime === 0) {
        u.totalTime = 1 / 0;
        break;
      }
      u.totalTime += R.delayTime;
    }
    return u;
  } catch (R) {
    throw R instanceof EvalError
      ? new Error(`error while parsing frame ${_} "${R.message}"`)
      : R;
  }
}
function qg(n) {
  const { context: e, radius: r, particle: o, delta: l } = n,
    u = o.image;
  if (!(u != null && u.gifData) || !u.gif) return;
  const c = new OffscreenCanvas(u.gifData.width, u.gifData.height),
    d = c.getContext("2d");
  if (!d) throw new Error("could not create offscreen canvas context");
  ((d.imageSmoothingQuality = "low"),
    (d.imageSmoothingEnabled = !1),
    d.clearRect(Rt.x, Rt.y, c.width, c.height),
    o.gifLoopCount === void 0 && (o.gifLoopCount = u.gifLoopCount ?? i3));
  let p = o.gifFrame ?? $g;
  const m = { x: -u.gifData.width * Qh, y: -u.gifData.height * Qh },
    g = u.gifData.frames[p];
  if ((o.gifTime === void 0 && (o.gifTime = jg), !!g.bitmap)) {
    switch (
      (e.scale(r / u.gifData.width, r / u.gifData.height), g.disposalMethod)
    ) {
      case ln.UndefinedA:
      case ln.UndefinedB:
      case ln.UndefinedC:
      case ln.UndefinedD:
      case ln.Replace:
        (d.drawImage(g.bitmap, g.left, g.top),
          e.drawImage(c, m.x, m.y),
          d.clearRect(Rt.x, Rt.y, c.width, c.height));
        break;
      case ln.Combine:
        (d.drawImage(g.bitmap, g.left, g.top), e.drawImage(c, m.x, m.y));
        break;
      case ln.RestoreBackground:
        (d.drawImage(g.bitmap, g.left, g.top),
          e.drawImage(c, m.x, m.y),
          d.clearRect(Rt.x, Rt.y, c.width, c.height),
          u.gifData.globalColorTable.length
            ? d.putImageData(u.gifData.backgroundImage, m.x, m.y)
            : d.putImageData(
                u.gifData.frames[Zh].image,
                m.x + g.left,
                m.y + g.top,
              ));
        break;
      case ln.RestorePrevious:
        {
          const v = d.getImageData(Rt.x, Rt.y, c.width, c.height);
          (d.drawImage(g.bitmap, g.left, g.top),
            e.drawImage(c, m.x, m.y),
            d.clearRect(Rt.x, Rt.y, c.width, c.height),
            d.putImageData(v, Rt.x, Rt.y));
        }
        break;
    }
    if (((o.gifTime += l.value), o.gifTime > g.delayTime)) {
      if (((o.gifTime -= g.delayTime), ++p >= u.gifData.frames.length)) {
        if (--o.gifLoopCount <= i3) return;
        ((p = Zh), d.clearRect(Rt.x, Rt.y, c.width, c.height));
      }
      o.gifFrame = p;
    }
    e.scale(u.gifData.width / r, u.gifData.height / r);
  }
}
async function Gg(n) {
  if (n.type !== "gif") {
    await aa(n);
    return;
  }
  n.loading = !0;
  try {
    ((n.gifData = await Wg(n.source)),
      (n.gifLoopCount = Vg(n.gifData) ?? i3),
      n.gifLoopCount || (n.gifLoopCount = 1 / 0));
  } catch {
    n.error = !0;
  }
  n.loading = !1;
}
const Qg = 2,
  Zg = 1,
  Kg = 12,
  Yg = 1;
class Xg {
  constructor(e) {
    ((this.validTypes = ["image", "images"]),
      (this.loadImageShape = async (r) => {
        if (!this._engine.loadImage)
          throw new Error(`${Kt} image shape not initialized`);
        await this._engine.loadImage({
          gif: r.gif,
          name: r.name,
          replaceColor: r.replaceColor ?? !1,
          src: r.src,
        });
      }),
      (this._engine = e));
  }
  addImage(e) {
    (this._engine.images || (this._engine.images = []),
      this._engine.images.push(e));
  }
  draw(e) {
    const { context: r, radius: o, particle: l, opacity: u } = e,
      c = l.image,
      d = c == null ? void 0 : c.element;
    if (c) {
      if (((r.globalAlpha = u), c.gif && c.gifData)) qg(e);
      else if (d) {
        const p = c.ratio,
          m = { x: -o, y: -o },
          g = o * Qg;
        r.drawImage(d, m.x, m.y, g, g / p);
      }
      r.globalAlpha = Zg;
    }
  }
  getSidesCount() {
    return Kg;
  }
  async init(e) {
    const r = e.actualOptions;
    if (!(!r.preload || !this._engine.loadImage))
      for (const o of r.preload) await this._engine.loadImage(o);
  }
  loadShape(e) {
    if (e.shape !== "image" && e.shape !== "images") return;
    this._engine.images || (this._engine.images = []);
    const r = e.shapeData;
    if (!r) return;
    this._engine.images.find((l) => l.name === r.name || l.source === r.src) ||
      this.loadImageShape(r).then(() => {
        this.loadShape(e);
      });
  }
  particleInit(e, r) {
    if (r.shape !== "image" && r.shape !== "images") return;
    this._engine.images || (this._engine.images = []);
    const o = this._engine.images,
      l = r.shapeData;
    if (!l) return;
    const u = r.getFillColor(),
      c = o.find((p) => p.name === l.name || p.source === l.src);
    if (!c) return;
    const d = l.replaceColor ?? c.replaceColor;
    if (c.loading) {
      setTimeout(() => {
        this.particleInit(e, r);
      });
      return;
    }
    (async () => {
      let p;
      (c.svgData && u
        ? (p = await Ag(c, l, u, r))
        : (p = {
            color: u,
            data: c,
            element: c.element,
            gif: c.gif,
            gifData: c.gifData,
            gifLoopCount: c.gifLoopCount,
            loaded: !0,
            ratio: l.width && l.height ? l.width / l.height : (c.ratio ?? Yg),
            replaceColor: d,
            source: l.src,
          }),
        p.ratio || (p.ratio = 1));
      const m = l.fill ?? r.shapeFill,
        g = l.close ?? r.shapeClose,
        v = { image: p, fill: m, close: g };
      ((r.image = v.image), (r.shapeFill = v.fill), (r.shapeClose = v.close));
    })();
  }
}
class Jg {
  constructor() {
    ((this.src = ""), (this.gif = !1));
  }
  load(e) {
    $(e) ||
      (e.gif !== void 0 && (this.gif = e.gif),
      e.height !== void 0 && (this.height = e.height),
      e.name !== void 0 && (this.name = e.name),
      e.replaceColor !== void 0 && (this.replaceColor = e.replaceColor),
      e.src !== void 0 && (this.src = e.src),
      e.width !== void 0 && (this.width = e.width));
  }
}
class ev {
  constructor(e) {
    ((this.id = "imagePreloader"), (this._engine = e));
  }
  async getPlugin() {
    return (await Promise.resolve(), {});
  }
  loadOptions(e, r) {
    if (!(r != null && r.preload)) return;
    e.preload || (e.preload = []);
    const o = e.preload;
    for (const l of r.preload) {
      const u = o.find((c) => c.name === l.name || c.src === l.src);
      if (u) u.load(l);
      else {
        const c = new Jg();
        (c.load(l), o.push(c));
      }
    }
  }
  needsPlugin() {
    return !0;
  }
}
const tv = 3;
function nv(n) {
  n.loadImage ||
    (n.loadImage = async (e) => {
      if (!e.name && !e.src) throw new Error(`${Kt} no image source provided`);
      if (
        (n.images || (n.images = []),
        !n.images.find((r) => r.name === e.name || r.source === e.src))
      )
        try {
          const r = {
            gif: e.gif ?? !1,
            name: e.name ?? e.src,
            source: e.src,
            type: e.src.substring(e.src.length - tv),
            error: !1,
            loading: !0,
            replaceColor: e.replaceColor,
            ratio: e.width && e.height ? e.width / e.height : void 0,
          };
          n.images.push(r);
          let o;
          (e.gif ? (o = Gg) : (o = e.replaceColor ? Fg : aa), await o(r));
        } catch {
          throw new Error(`${Kt} ${e.name ?? e.src} not found`);
        }
    });
}
async function iv(n, e = !0) {
  (re(n, "3.7.1"), nv(n));
  const r = new ev(n);
  (await n.addPlugin(r, e), await n.addShape(new Xg(n), e));
}
class rv extends hn {
  constructor() {
    (super(), (this.sync = !1));
  }
  load(e) {
    $(e) || (super.load(e), e.sync !== void 0 && (this.sync = e.sync));
  }
}
class ov extends hn {
  constructor() {
    (super(), (this.sync = !1));
  }
  load(e) {
    $(e) || (super.load(e), e.sync !== void 0 && (this.sync = e.sync));
  }
}
class sv {
  constructor() {
    ((this.count = 0), (this.delay = new rv()), (this.duration = new ov()));
  }
  load(e) {
    $(e) ||
      (e.count !== void 0 && (this.count = e.count),
      this.delay.load(e.delay),
      this.duration.load(e.duration));
  }
}
const _r = 0,
  lv = -1,
  Kh = 0,
  Yh = 0;
function av(n, e, r) {
  if (!n.life) return;
  const o = n.life;
  let l = !1;
  if (n.spawning)
    if (((o.delayTime += e.value), o.delayTime >= n.life.delay))
      ((l = !0), (n.spawning = !1), (o.delayTime = _r), (o.time = _r));
    else return;
  if (
    o.duration === lv ||
    n.spawning ||
    (l ? (o.time = _r) : (o.time += e.value), o.time < o.duration)
  )
    return;
  if (
    ((o.time = _r), n.life.count > Kh && n.life.count--, n.life.count === Kh)
  ) {
    n.destroy();
    return;
  }
  const u = ee(Yh, r.width),
    c = ee(Yh, r.width);
  ((n.position.x = ut(u)),
    (n.position.y = ut(c)),
    (n.spawning = !0),
    (o.delayTime = _r),
    (o.time = _r),
    n.reset());
  const d = n.options.life;
  d &&
    ((o.delay = H(d.delay.value) * Fe),
    (o.duration = H(d.duration.value) * Fe));
}
const Di = 0,
  Xh = 1,
  Jh = -1;
class uv {
  constructor(e) {
    this.container = e;
  }
  init(e) {
    const r = this.container,
      o = e.options,
      l = o.life;
    l &&
      ((e.life = {
        delay: r.retina.reduceFactor
          ? ((H(l.delay.value) * (l.delay.sync ? Xh : se())) /
              r.retina.reduceFactor) *
            Fe
          : Di,
        delayTime: Di,
        duration: r.retina.reduceFactor
          ? ((H(l.duration.value) * (l.duration.sync ? Xh : se())) /
              r.retina.reduceFactor) *
            Fe
          : Di,
        time: Di,
        count: l.count,
      }),
      e.life.duration <= Di && (e.life.duration = Jh),
      e.life.count <= Di && (e.life.count = Jh),
      e.life && (e.spawning = e.life.delay > Di));
  }
  isEnabled(e) {
    return !e.destroyed;
  }
  loadOptions(e, ...r) {
    e.life || (e.life = new sv());
    for (const o of r) e.life.load(o == null ? void 0 : o.life);
  }
  update(e, r) {
    !this.isEnabled(e) || !e.life || av(e, r, this.container.canvas.size);
  }
}
async function cv(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater(
      "life",
      async (r) => Promise.resolve(new uv(r)),
      e,
    ));
}
function fv(n) {
  const { context: e, particle: r, radius: o } = n,
    l = r.shapeData,
    u = 0;
  (e.moveTo(-o, u),
    e.lineTo(o, u),
    (e.lineCap = (l == null ? void 0 : l.cap) ?? "butt"));
}
const dv = 1;
class hv {
  constructor() {
    this.validTypes = ["line"];
  }
  draw(e) {
    fv(e);
  }
  getSidesCount() {
    return dv;
  }
}
async function pv(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new hv(), e));
}
const e0 = 0.5;
class mv {
  init() {}
  isEnabled(e) {
    return (
      !Qi() &&
      !e.destroyed &&
      e.container.actualOptions.interactivity.events.onHover.parallax.enable
    );
  }
  move(e) {
    const r = e.container,
      o = r.actualOptions,
      l = o.interactivity.events.onHover.parallax;
    if (Qi() || !l.enable) return;
    const u = l.force,
      c = r.interactivity.mouse.position;
    if (!c) return;
    const d = r.canvas.size,
      p = { x: d.width * e0, y: d.height * e0 },
      m = l.smooth,
      g = e.getRadius() / u,
      v = { x: (c.x - p.x) * g, y: (c.y - p.y) * g },
      { offset: C } = e;
    ((C.x += (v.x - C.x) / m), (C.y += (v.y - C.y) / m));
  }
}
async function yv(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addMover("parallax", () => Promise.resolve(new mv()), e));
}
const t0 = 1e3,
  gv = 1;
class vv extends x3 {
  constructor(e) {
    super(e);
  }
  clear() {}
  init() {}
  interact(e) {
    const r = this.container;
    e.attractDistance === void 0 &&
      (e.attractDistance =
        H(e.options.move.attract.distance) * r.retina.pixelRatio);
    const o = e.attractDistance,
      l = e.getPosition(),
      u = r.particles.quadTree.queryCircle(l, o);
    for (const c of u) {
      if (
        e === c ||
        !c.options.move.attract.enable ||
        c.destroyed ||
        c.spawning
      )
        continue;
      const d = c.getPosition(),
        { dx: p, dy: m } = Ct(l, d),
        g = e.options.move.attract.rotate,
        v = p / (g.x * t0),
        C = m / (g.y * t0),
        x = c.size.value / e.size.value,
        b = gv / x;
      ((e.velocity.x -= v * x),
        (e.velocity.y -= C * x),
        (c.velocity.x += v * b),
        (c.velocity.y += C * b));
    }
  }
  isEnabled(e) {
    return e.options.move.attract.enable;
  }
  reset() {}
}
async function Cv(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "particlesAttract",
      (r) => Promise.resolve(new vv(r)),
      e,
    ));
}
const wv = 0.5,
  xv = 10,
  _v = 0;
function n0(n, e, r, o, l, u) {
  const c = Yt((n.options.collisions.absorb.speed * l.factor) / xv, _v, o);
  ((n.size.value += c * wv),
    (r.size.value -= c),
    o <= u && ((r.size.value = 0), r.destroy()));
}
function bv(n, e, r, o) {
  const l = n.getRadius(),
    u = e.getRadius();
  l === void 0 && u !== void 0
    ? n.destroy()
    : l !== void 0 && u === void 0
      ? e.destroy()
      : l !== void 0 &&
        u !== void 0 &&
        (l >= u ? n0(n, l, e, u, r, o) : n0(e, u, n, l, r, o));
}
const i0 = (n) => {
  (n.collisionMaxSpeed === void 0 &&
    (n.collisionMaxSpeed = H(n.options.collisions.maxSpeed)),
    n.velocity.length > n.collisionMaxSpeed &&
      (n.velocity.length = n.collisionMaxSpeed));
};
function H1(n, e) {
  (y1(Xc(n), Xc(e)), i0(n), i0(e));
}
function kv(n, e) {
  (!n.unbreakable && !e.unbreakable && H1(n, e),
    n.getRadius() === void 0 && e.getRadius() !== void 0
      ? n.destroy()
      : n.getRadius() !== void 0 && e.getRadius() === void 0
        ? e.destroy()
        : n.getRadius() !== void 0 &&
          e.getRadius() !== void 0 &&
          (n.getRadius() >= e.getRadius() ? e : n).destroy());
}
function Sv(n, e, r, o) {
  switch (n.options.collisions.mode) {
    case Dr.absorb: {
      bv(n, e, r, o);
      break;
    }
    case Dr.bounce: {
      H1(n, e);
      break;
    }
    case Dr.destroy: {
      kv(n, e);
      break;
    }
  }
}
const Ev = 2;
class Pv extends x3 {
  constructor(e) {
    super(e);
  }
  clear() {}
  init() {}
  interact(e, r) {
    if (e.destroyed || e.spawning) return;
    const o = this.container,
      l = e.getPosition(),
      u = e.getRadius(),
      c = o.particles.quadTree.queryCircle(l, u * Ev);
    for (const d of c) {
      if (
        e === d ||
        !d.options.collisions.enable ||
        e.options.collisions.mode !== d.options.collisions.mode ||
        d.destroyed ||
        d.spawning
      )
        continue;
      const p = d.getPosition(),
        m = d.getRadius();
      if (Math.abs(Math.round(l.z) - Math.round(p.z)) > u + m) continue;
      const g = kt(l, p),
        v = u + m;
      g > v || Sv(e, d, r, o.retina.pixelRatio);
    }
  }
  isEnabled(e) {
    return e.options.collisions.enable;
  }
  reset() {}
}
async function zv(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addInteractor(
      "particlesCollisions",
      (r) => Promise.resolve(new Pv(r)),
      e,
    ));
}
const Tc = 2;
class Ov extends wt {
  constructor(e, r, o, l) {
    (super(e, r, o), (this.canvasSize = l), (this.canvasSize = { ...l }));
  }
  contains(e) {
    const { width: r, height: o } = this.canvasSize,
      { x: l, y: u } = e;
    return (
      super.contains(e) ||
      super.contains({ x: l - r, y: u }) ||
      super.contains({ x: l - r, y: u - o }) ||
      super.contains({ x: l, y: u - o })
    );
  }
  intersects(e) {
    if (super.intersects(e)) return !0;
    const r = e,
      o = e,
      l = {
        x: e.position.x - this.canvasSize.width,
        y: e.position.y - this.canvasSize.height,
      };
    if (o.radius !== void 0) {
      const u = new wt(l.x, l.y, o.radius * Tc);
      return super.intersects(u);
    } else if (r.size !== void 0) {
      const u = new dn(l.x, l.y, r.size.width * Tc, r.size.height * Tc);
      return super.intersects(u);
    }
    return !1;
  }
}
class Mv {
  constructor() {
    ((this.blur = 5),
      (this.color = new Ve()),
      (this.color.value = "#000"),
      (this.enable = !1));
  }
  load(e) {
    $(e) ||
      (e.blur !== void 0 && (this.blur = e.blur),
      (this.color = Ve.create(this.color, e.color)),
      e.enable !== void 0 && (this.enable = e.enable));
  }
}
class Rv {
  constructor() {
    ((this.enable = !1), (this.frequency = 1));
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.frequency !== void 0 && (this.frequency = e.frequency),
      e.opacity !== void 0 && (this.opacity = e.opacity));
  }
}
class Dv {
  constructor() {
    ((this.blink = !1),
      (this.color = new Ve()),
      (this.color.value = "#fff"),
      (this.consent = !1),
      (this.distance = 100),
      (this.enable = !1),
      (this.frequency = 1),
      (this.opacity = 1),
      (this.shadow = new Mv()),
      (this.triangles = new Rv()),
      (this.width = 1),
      (this.warp = !1));
  }
  load(e) {
    $(e) ||
      (e.id !== void 0 && (this.id = e.id),
      e.blink !== void 0 && (this.blink = e.blink),
      (this.color = Ve.create(this.color, e.color)),
      e.consent !== void 0 && (this.consent = e.consent),
      e.distance !== void 0 && (this.distance = e.distance),
      e.enable !== void 0 && (this.enable = e.enable),
      e.frequency !== void 0 && (this.frequency = e.frequency),
      e.opacity !== void 0 && (this.opacity = e.opacity),
      this.shadow.load(e.shadow),
      this.triangles.load(e.triangles),
      e.width !== void 0 && (this.width = e.width),
      e.warp !== void 0 && (this.warp = e.warp));
  }
}
const r0 = 2,
  Tv = 1,
  bl = { x: 0, y: 0 },
  Iv = 0;
function Lv(n, e, r, o, l) {
  const { dx: u, dy: c, distance: d } = Ct(n, e);
  if (!l || d <= r) return d;
  const p = { x: Math.abs(u), y: Math.abs(c) },
    m = { x: Math.min(p.x, o.width - p.x), y: Math.min(p.y, o.height - p.y) };
  return Math.sqrt(m.x ** r0 + m.y ** r0);
}
class Fv extends x3 {
  constructor(e, r) {
    (super(e),
      (this._setColor = (o) => {
        if (!o.options.links) return;
        const l = this._linkContainer,
          u = o.options.links;
        let c =
          u.id === void 0
            ? l.particles.linksColor
            : l.particles.linksColors.get(u.id);
        if (c) return;
        const d = u.color;
        ((c = k1(this._engine, d, u.blink, u.consent)),
          u.id === void 0
            ? (l.particles.linksColor = c)
            : l.particles.linksColors.set(u.id, c));
      }),
      (this._linkContainer = e),
      (this._engine = r));
  }
  clear() {}
  init() {
    ((this._linkContainer.particles.linksColor = void 0),
      (this._linkContainer.particles.linksColors = new Map()));
  }
  interact(e) {
    if (!e.options.links) return;
    e.links = [];
    const r = e.getPosition(),
      o = this.container,
      l = o.canvas.size;
    if (r.x < bl.x || r.y < bl.y || r.x > l.width || r.y > l.height) return;
    const u = e.options.links,
      c = u.opacity,
      d = e.retina.linksDistance ?? Iv,
      p = u.warp;
    let m;
    p ? (m = new Ov(r.x, r.y, d, l)) : (m = new wt(r.x, r.y, d));
    const g = o.particles.quadTree.query(m);
    for (const v of g) {
      const C = v.options.links;
      if (
        e === v ||
        !(C != null && C.enable) ||
        u.id !== C.id ||
        v.spawning ||
        v.destroyed ||
        !v.links ||
        e.links.some((E) => E.destination === v) ||
        v.links.some((E) => E.destination === e)
      )
        continue;
      const x = v.getPosition();
      if (x.x < bl.x || x.y < bl.y || x.x > l.width || x.y > l.height) continue;
      const b = Lv(r, x, d, l, p && C.warp);
      if (b > d) continue;
      const _ = (Tv - b / d) * c;
      (this._setColor(e), e.links.push({ destination: v, opacity: _ }));
    }
  }
  isEnabled(e) {
    var r;
    return !!((r = e.options.links) != null && r.enable);
  }
  loadParticlesOptions(e, ...r) {
    e.links || (e.links = new Dv());
    for (const o of r) e.links.load(o == null ? void 0 : o.links);
  }
  reset() {}
}
async function Av(n, e = !0) {
  await n.addInteractor(
    "particlesLinks",
    async (r) => Promise.resolve(new Fv(r, n)),
    e,
  );
}
function Nv(n, e, r, o) {
  (n.beginPath(),
    n.moveTo(e.x, e.y),
    n.lineTo(r.x, r.y),
    n.lineTo(o.x, o.y),
    n.closePath());
}
function $v(n) {
  let e = !1;
  const {
    begin: r,
    end: o,
    engine: l,
    maxDistance: u,
    context: c,
    canvasSize: d,
    width: p,
    backgroundMask: m,
    colorLine: g,
    opacity: v,
    links: C,
  } = n;
  if (kt(r, o) <= u) (Vo(c, r, o), (e = !0));
  else if (C.warp) {
    let b, _;
    const E = { x: o.x - d.width, y: o.y },
      T = Ct(r, E);
    if (T.distance <= u) {
      const D = r.y - (T.dy / T.dx) * r.x;
      ((b = { x: 0, y: D }), (_ = { x: d.width, y: D }));
    } else {
      const D = { x: o.x, y: o.y - d.height },
        I = Ct(r, D);
      if (I.distance <= u) {
        const N = -(r.y - (I.dy / I.dx) * r.x) / (I.dy / I.dx);
        ((b = { x: N, y: 0 }), (_ = { x: N, y: d.height }));
      } else {
        const R = { x: o.x - d.width, y: o.y - d.height },
          N = Ct(r, R);
        if (N.distance <= u) {
          const F = r.y - (N.dy / N.dx) * r.x;
          ((b = { x: -F / (N.dy / N.dx), y: F }),
            (_ = { x: b.x + d.width, y: b.y + d.height }));
        }
      }
    }
    b && _ && (Vo(c, r, b), Vo(c, o, _), (e = !0));
  }
  if (!e) return;
  ((c.lineWidth = p),
    m.enable && (c.globalCompositeOperation = m.composite),
    (c.strokeStyle = Sn(g, v)));
  const { shadow: x } = C;
  if (x.enable) {
    const b = Qt(l, x.color);
    b && ((c.shadowBlur = x.blur), (c.shadowColor = Sn(b)));
  }
  c.stroke();
}
function jv(n) {
  const {
    context: e,
    pos1: r,
    pos2: o,
    pos3: l,
    backgroundMask: u,
    colorTriangle: c,
    opacityTriangle: d,
  } = n;
  (Nv(e, r, o, l),
    u.enable && (e.globalCompositeOperation = u.composite),
    (e.fillStyle = Sn(c, d)),
    e.fill());
}
function Bv(n) {
  return (n.sort((e, r) => e - r), n.join("_"));
}
function o0(n, e) {
  const r = Bv(n.map((l) => l.id));
  let o = e.get(r);
  return (o === void 0 && ((o = se()), e.set(r, o)), o);
}
const s0 = 0,
  Ic = 0,
  l0 = 0,
  Uv = 0.5,
  Hv = 1;
class Vv {
  constructor(e, r) {
    ((this._drawLinkLine = (o, l) => {
      const u = o.options.links;
      if (!(u != null && u.enable)) return;
      const c = this._container,
        d = c.actualOptions,
        p = l.destination,
        m = o.getPosition(),
        g = p.getPosition();
      let v = l.opacity;
      c.canvas.draw((C) => {
        var D;
        let x;
        const b = (D = o.options.twinkle) == null ? void 0 : D.lines;
        if (b != null && b.enable) {
          const I = b.frequency,
            R = Qt(this._engine, b.color);
          se() < I && R && ((x = R), (v = H(b.opacity)));
        }
        if (!x) {
          const I =
            u.id !== void 0
              ? c.particles.linksColors.get(u.id)
              : c.particles.linksColor;
          x = Jc(o, p, I);
        }
        if (!x) return;
        const _ = o.retina.linksWidth ?? Ic,
          E = o.retina.linksDistance ?? l0,
          { backgroundMask: T } = d;
        $v({
          context: C,
          width: _,
          begin: m,
          end: g,
          engine: this._engine,
          maxDistance: E,
          canvasSize: c.canvas.size,
          links: u,
          backgroundMask: T,
          colorLine: x,
          opacity: v,
        });
      });
    }),
      (this._drawLinkTriangle = (o, l, u) => {
        const c = o.options.links;
        if (!(c != null && c.enable)) return;
        const d = c.triangles;
        if (!d.enable) return;
        const p = this._container,
          m = p.actualOptions,
          g = l.destination,
          v = u.destination,
          C = d.opacity ?? (l.opacity + u.opacity) * Uv;
        C <= s0 ||
          p.canvas.draw((x) => {
            const b = o.getPosition(),
              _ = g.getPosition(),
              E = v.getPosition(),
              T = o.retina.linksDistance ?? l0;
            if (kt(b, _) > T || kt(E, _) > T || kt(E, b) > T) return;
            let D = Qt(this._engine, d.color);
            if (!D) {
              const I =
                c.id !== void 0
                  ? p.particles.linksColors.get(c.id)
                  : p.particles.linksColor;
              D = Jc(o, g, I);
            }
            D &&
              jv({
                context: x,
                pos1: b,
                pos2: _,
                pos3: E,
                backgroundMask: m.backgroundMask,
                colorTriangle: D,
                opacityTriangle: C,
              });
          });
      }),
      (this._drawTriangles = (o, l, u, c) => {
        var m, g, v;
        const d = u.destination;
        if (!(
          (m = o.links) != null &&
          m.triangles.enable &&
          (g = d.options.links) != null &&
          g.triangles.enable
        ))
          return;
        const p =
          (v = d.links) == null
            ? void 0
            : v.filter((C) => {
                const x = this._getLinkFrequency(d, C.destination);
                return (
                  d.options.links &&
                  x <= d.options.links.frequency &&
                  c.findIndex((_) => _.destination === C.destination) >= 0
                );
              });
        if (p != null && p.length)
          for (const C of p) {
            const x = C.destination;
            this._getTriangleFrequency(l, d, x) > o.links.triangles.frequency ||
              this._drawLinkTriangle(l, u, C);
          }
      }),
      (this._getLinkFrequency = (o, l) => o0([o, l], this._freqs.links)),
      (this._getTriangleFrequency = (o, l, u) =>
        o0([o, l, u], this._freqs.triangles)),
      (this._container = e),
      (this._engine = r),
      (this._freqs = { links: new Map(), triangles: new Map() }));
  }
  drawParticle(e, r) {
    const { links: o, options: l } = r;
    if (!(o != null && o.length)) return;
    const u = o.filter(
      (c) =>
        l.links &&
        (l.links.frequency >= Hv ||
          this._getLinkFrequency(r, c.destination) <= l.links.frequency),
    );
    for (const c of u)
      (this._drawTriangles(l, r, c, u),
        c.opacity > s0 &&
          (r.retina.linksWidth ?? Ic) > Ic &&
          this._drawLinkLine(r, c));
  }
  async init() {
    ((this._freqs.links = new Map()),
      (this._freqs.triangles = new Map()),
      await Promise.resolve());
  }
  particleCreated(e) {
    if (((e.links = []), !e.options.links)) return;
    const r = this._container.retina.pixelRatio,
      { retina: o } = e,
      { distance: l, width: u } = e.options.links;
    ((o.linksDistance = l * r), (o.linksWidth = u * r));
  }
  particleDestroyed(e) {
    e.links = [];
  }
}
class Wv {
  constructor(e) {
    ((this.id = "links"), (this._engine = e));
  }
  getPlugin(e) {
    return Promise.resolve(new Vv(e, this._engine));
  }
  loadOptions() {}
  needsPlugin() {
    return !0;
  }
}
async function qv(n, e = !0) {
  const r = new Wv(n);
  await n.addPlugin(r, e);
}
async function Gv(n, e = !0) {
  (re(n, "3.7.1"), await Av(n, e), await qv(n, e));
}
const Qv = 180,
  kl = { x: 0, y: 0 },
  Zv = 2;
function Kv(n, e, r) {
  const { context: o } = n,
    l = r.count.numerator * r.count.denominator,
    u = r.count.numerator / r.count.denominator,
    c = (Qv * (u - Zv)) / u,
    d = Math.PI - $n(c);
  if (o) {
    (o.beginPath(), o.translate(e.x, e.y), o.moveTo(kl.x, kl.y));
    for (let p = 0; p < l; p++)
      (o.lineTo(r.length, kl.y), o.translate(r.length, kl.y), o.rotate(d));
  }
}
const Yv = 5;
class V1 {
  draw(e) {
    const { particle: r, radius: o } = e,
      l = this.getCenter(r, o),
      u = this.getSidesData(r, o);
    Kv(e, l, u);
  }
  getSidesCount(e) {
    const r = e.shapeData;
    return Math.round(H((r == null ? void 0 : r.sides) ?? Yv));
  }
}
const a0 = 3.5,
  u0 = 2.66,
  Xv = 3;
class Jv extends V1 {
  constructor() {
    (super(...arguments), (this.validTypes = ["polygon"]));
  }
  getCenter(e, r) {
    return { x: -r / (e.sides / a0), y: -r / (u0 / a0) };
  }
  getSidesData(e, r) {
    const o = e.sides;
    return {
      count: { denominator: 1, numerator: o },
      length: (r * u0) / (o / Xv),
    };
  }
}
const eC = 1.66,
  tC = 3,
  nC = 2;
class iC extends V1 {
  constructor() {
    (super(...arguments), (this.validTypes = ["triangle"]));
  }
  getCenter(e, r) {
    return { x: -r, y: r / eC };
  }
  getSidesCount() {
    return tC;
  }
  getSidesData(e, r) {
    const o = r * nC;
    return { count: { denominator: 2, numerator: 3 }, length: o };
  }
}
async function rC(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new Jv(), e));
}
async function oC(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new iC(), e));
}
async function sC(n, e = !0) {
  (re(n, "3.7.1"), await rC(n, e), await oC(n, e));
}
class lC {
  constructor() {
    ((this.enable = !1), (this.speed = 0), (this.decay = 0), (this.sync = !1));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.speed !== void 0 && (this.speed = ee(e.speed)),
      e.decay !== void 0 && (this.decay = ee(e.decay)),
      e.sync !== void 0 && (this.sync = e.sync));
  }
}
class aC extends hn {
  constructor() {
    (super(),
      (this.animation = new lC()),
      (this.direction = yt.clockwise),
      (this.path = !1),
      (this.value = 0));
  }
  load(e) {
    $(e) ||
      (super.load(e),
      e.direction !== void 0 && (this.direction = e.direction),
      this.animation.load(e.animation),
      e.path !== void 0 && (this.path = e.path));
  }
}
const W1 = 2,
  uC = Math.PI * W1,
  cC = 1,
  fC = 360;
class dC {
  constructor(e) {
    this.container = e;
  }
  init(e) {
    const r = e.options.rotate;
    if (!r) return;
    ((e.rotate = {
      enable: r.animation.enable,
      value: $n(H(r.value)),
      min: 0,
      max: uC,
    }),
      (e.pathRotation = r.path));
    let o = r.direction;
    switch (
      (o === yt.random &&
        (o = Math.floor(se() * W1) > 0 ? yt.counterClockwise : yt.clockwise),
      o)
    ) {
      case yt.counterClockwise:
      case "counterClockwise":
        e.rotate.status = $e.decreasing;
        break;
      case yt.clockwise:
        e.rotate.status = $e.increasing;
        break;
    }
    const l = r.animation;
    (l.enable &&
      ((e.rotate.decay = cC - H(l.decay)),
      (e.rotate.velocity =
        (H(l.speed) / fC) * this.container.retina.reduceFactor),
      l.sync || (e.rotate.velocity *= se())),
      (e.rotation = e.rotate.value));
  }
  isEnabled(e) {
    const r = e.options.rotate;
    return r
      ? !e.destroyed &&
          !e.spawning &&
          (!!r.value || r.animation.enable || r.path)
      : !1;
  }
  loadOptions(e, ...r) {
    e.rotate || (e.rotate = new aC());
    for (const o of r) e.rotate.load(o == null ? void 0 : o.rotate);
  }
  update(e, r) {
    this.isEnabled(e) &&
      ((e.isRotating = !!e.rotate),
      e.rotate &&
        (la(e, e.rotate, !1, pi.none, r), (e.rotation = e.rotate.value)));
  }
}
async function hC(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater("rotate", (r) => Promise.resolve(new dC(r)), e));
}
const pC = 2,
  mC = Math.sqrt(pC),
  yC = 2;
function gC(n) {
  const { context: e, radius: r } = n,
    o = r / mC,
    l = o * yC;
  e.rect(-o, -o, l, l);
}
const vC = 4;
class CC {
  constructor() {
    this.validTypes = ["edge", "square"];
  }
  draw(e) {
    gC(e);
  }
  getSidesCount() {
    return vC;
  }
}
async function wC(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new CC(), e));
}
const xC = 2,
  br = { x: 0, y: 0 };
function _C(n) {
  const { context: e, particle: r, radius: o } = n,
    l = r.sides,
    u = r.starInset ?? xC;
  e.moveTo(br.x, br.y - o);
  for (let c = 0; c < l; c++)
    (e.rotate(Math.PI / l),
      e.lineTo(br.x, br.y - o * u),
      e.rotate(Math.PI / l),
      e.lineTo(br.x, br.y - o));
}
const bC = 2,
  kC = 5;
class SC {
  constructor() {
    this.validTypes = ["star"];
  }
  draw(e) {
    _C(e);
  }
  getSidesCount(e) {
    const r = e.shapeData;
    return Math.round(H((r == null ? void 0 : r.sides) ?? kC));
  }
  particleInit(e, r) {
    const o = r.shapeData;
    r.starInset = H((o == null ? void 0 : o.inset) ?? bC);
  }
}
async function EC(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new SC(), e));
}
const PC = 1;
class zC {
  constructor(e, r) {
    ((this._container = e), (this._engine = r));
  }
  init(e) {
    var c;
    const r = this._container,
      o = e.options,
      l = ct(o.stroke, e.id, o.reduceDuplicates);
    ((e.strokeWidth = H(l.width) * r.retina.pixelRatio),
      (e.strokeOpacity = H(l.opacity ?? PC)),
      (e.strokeAnimation = (c = l.color) == null ? void 0 : c.animation));
    const u = mi(this._engine, l.color) ?? e.getFillColor();
    u && (e.strokeColor = S1(u, e.strokeAnimation, r.retina.reduceFactor));
  }
  isEnabled(e) {
    const r = e.strokeAnimation,
      { strokeColor: o } = e;
    return (
      !e.destroyed &&
      !e.spawning &&
      !!r &&
      (((o == null ? void 0 : o.h.value) !== void 0 && o.h.enable) ||
        ((o == null ? void 0 : o.s.value) !== void 0 && o.s.enable) ||
        ((o == null ? void 0 : o.l.value) !== void 0 && o.l.enable))
    );
  }
  update(e, r) {
    this.isEnabled(e) && E1(e.strokeColor, r);
  }
}
async function OC(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater(
      "strokeColor",
      (r) => Promise.resolve(new zC(r, n)),
      e,
    ));
}
async function MC(n, e = !0) {
  (re(n, "3.7.1"),
    await yv(n, !1),
    await wy(n, !1),
    await Oy(n, !1),
    await Ay(n, !1),
    await Gy(n, !1),
    await ig(n, !1),
    await sg(n, !1),
    await fg(n, !1),
    await mg(n, !1),
    await Eg(n, !1),
    await Rg(n, !1),
    await Cv(n, !1),
    await zv(n, !1),
    await Gv(n, !1),
    await cy(n, !1),
    await hy(n, !1),
    await iv(n, !1),
    await pv(n, !1),
    await sC(n, !1),
    await wC(n, !1),
    await EC(n, !1),
    await cv(n, !1),
    await hC(n, !1),
    await OC(n, !1),
    await uy(n, e));
}
const q1 = 2,
  c0 = 0.5;
function RC(n) {
  const { context: e, particle: r, radius: o, opacity: l } = n,
    u = r.shapeData;
  if (!u) return;
  const c = u.value;
  if (c === void 0) return;
  r.text === void 0 && (r.text = ct(c, r.randomIndexData));
  const d = r.text,
    p = u.style ?? "",
    m = u.weight ?? "400",
    g = Math.round(o) * q1,
    v = u.font ?? "Verdana",
    C = r.shapeFill,
    x =
      d == null
        ? void 0
        : d.split(`
`);
  if (x) {
    ((e.font = `${p} ${m} ${g}px "${v}"`), (e.globalAlpha = l));
    for (let b = 0; b < x.length; b++) DC(e, x[b], o, l, b, C);
    e.globalAlpha = 1;
  }
}
function DC(n, e, r, o, l, u) {
  const c = e.length * r * c0,
    d = { x: -c, y: r * c0 },
    p = r * q1;
  u ? n.fillText(e, d.x, d.y + p * l) : n.strokeText(e, d.x, d.y + p * l);
}
class TC {
  constructor() {
    this.validTypes = ["text", "character", "char", "multiline-text"];
  }
  draw(e) {
    RC(e);
  }
  async init(e) {
    const r = e.actualOptions,
      { validTypes: o } = this;
    if (o.find((l) => Oe(l, r.particles.shape.type))) {
      const l = o.map((c) => r.particles.shape.options[c]).find((c) => !!c),
        u = [];
      (Ke(l, (c) => {
        u.push(Yc(c.font, c.weight));
      }),
        await Promise.all(u));
    }
  }
  particleInit(e, r) {
    if (!r.shape || !this.validTypes.includes(r.shape)) return;
    const o = r.shapeData;
    if (o === void 0) return;
    const l = o.value;
    l !== void 0 && (r.text = ct(l, r.randomIndexData));
  }
}
async function IC(n, e = !0) {
  (re(n, "3.7.1"), await n.addShape(new TC(), e));
}
var ci;
(function (n) {
  ((n.clockwise = "clockwise"),
    (n.counterClockwise = "counter-clockwise"),
    (n.random = "random"));
})(ci || (ci = {}));
class LC {
  constructor() {
    ((this.enable = !1), (this.speed = 0), (this.decay = 0), (this.sync = !1));
  }
  load(e) {
    $(e) ||
      (e.enable !== void 0 && (this.enable = e.enable),
      e.speed !== void 0 && (this.speed = ee(e.speed)),
      e.decay !== void 0 && (this.decay = ee(e.decay)),
      e.sync !== void 0 && (this.sync = e.sync));
  }
}
class FC extends hn {
  constructor() {
    (super(),
      (this.animation = new LC()),
      (this.direction = ci.clockwise),
      (this.enable = !1),
      (this.value = 0));
  }
  load(e) {
    (super.load(e),
      !$(e) &&
        (this.animation.load(e.animation),
        e.direction !== void 0 && (this.direction = e.direction),
        e.enable !== void 0 && (this.enable = e.enable)));
  }
}
const jo = 1,
  G1 = 2,
  AC = Math.PI * G1,
  NC = 360;
class $C {
  constructor(e) {
    this.container = e;
  }
  getTransformValues(e) {
    var o;
    const r = ((o = e.tilt) == null ? void 0 : o.enable) && e.tilt;
    return {
      b: r ? Math.cos(r.value) * r.cosDirection : void 0,
      c: r ? Math.sin(r.value) * r.sinDirection : void 0,
    };
  }
  init(e) {
    var u;
    const r = e.options.tilt;
    if (!r) return;
    e.tilt = {
      enable: r.enable,
      value: $n(H(r.value)),
      sinDirection: se() >= qi ? jo : -jo,
      cosDirection: se() >= qi ? jo : -jo,
      min: 0,
      max: AC,
    };
    let o = r.direction;
    switch (
      (o === ci.random &&
        (o = Math.floor(se() * G1) > 0 ? ci.counterClockwise : ci.clockwise),
      o)
    ) {
      case ci.counterClockwise:
      case "counterClockwise":
        e.tilt.status = $e.decreasing;
        break;
      case ci.clockwise:
        e.tilt.status = $e.increasing;
        break;
    }
    const l = (u = e.options.tilt) == null ? void 0 : u.animation;
    l != null &&
      l.enable &&
      ((e.tilt.decay = jo - H(l.decay)),
      (e.tilt.velocity =
        (H(l.speed) / NC) * this.container.retina.reduceFactor),
      l.sync || (e.tilt.velocity *= se()));
  }
  isEnabled(e) {
    var o;
    const r = (o = e.options.tilt) == null ? void 0 : o.animation;
    return !e.destroyed && !e.spawning && !!(r != null && r.enable);
  }
  loadOptions(e, ...r) {
    e.tilt || (e.tilt = new FC());
    for (const o of r) e.tilt.load(o == null ? void 0 : o.tilt);
  }
  async update(e, r) {
    !this.isEnabled(e) ||
      !e.tilt ||
      (la(e, e.tilt, !1, pi.none, r), await Promise.resolve());
  }
}
async function jC(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater("tilt", (r) => Promise.resolve(new $C(r)), e));
}
class f0 {
  constructor() {
    ((this.enable = !1), (this.frequency = 0.05), (this.opacity = 1));
  }
  load(e) {
    $(e) ||
      (e.color !== void 0 && (this.color = Ve.create(this.color, e.color)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.frequency !== void 0 && (this.frequency = e.frequency),
      e.opacity !== void 0 && (this.opacity = ee(e.opacity)));
  }
}
class BC {
  constructor() {
    ((this.lines = new f0()), (this.particles = new f0()));
  }
  load(e) {
    $(e) || (this.lines.load(e.lines), this.particles.load(e.particles));
  }
}
class UC {
  constructor(e) {
    this._engine = e;
  }
  getColorStyles(e, r, o, l) {
    const u = e.options,
      c = u.twinkle;
    if (!c) return {};
    const d = c.particles,
      p = d.enable && se() < d.frequency,
      m = e.options.zIndex,
      g = 1,
      v = (g - e.zIndexFactor) ** m.opacityRate,
      C = p ? H(d.opacity) * v : l,
      x = mi(this._engine, d.color),
      b = x ? Ur(x, C) : void 0,
      _ = {},
      E = p && b;
    return ((_.fill = E ? b : void 0), (_.stroke = E ? b : void 0), _);
  }
  async init() {
    await Promise.resolve();
  }
  isEnabled(e) {
    const r = e.options,
      o = r.twinkle;
    return o ? o.particles.enable : !1;
  }
  loadOptions(e, ...r) {
    e.twinkle || (e.twinkle = new BC());
    for (const o of r) e.twinkle.load(o == null ? void 0 : o.twinkle);
  }
  async update() {
    await Promise.resolve();
  }
}
async function HC(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater("twinkle", () => Promise.resolve(new UC(n)), e));
}
class VC {
  constructor() {
    ((this.angle = 50), (this.move = 10));
  }
  load(e) {
    $(e) ||
      (e.angle !== void 0 && (this.angle = ee(e.angle)),
      e.move !== void 0 && (this.move = ee(e.move)));
  }
}
class WC {
  constructor() {
    ((this.distance = 5), (this.enable = !1), (this.speed = new VC()));
  }
  load(e) {
    if (
      !$(e) &&
      (e.distance !== void 0 && (this.distance = ee(e.distance)),
      e.enable !== void 0 && (this.enable = e.enable),
      e.speed !== void 0)
    )
      if (jt(e.speed)) this.speed.load({ angle: e.speed });
      else {
        const r = e.speed;
        r.min !== void 0
          ? this.speed.load({ angle: r })
          : this.speed.load(e.speed);
      }
  }
}
const qC = 0,
  GC = 2,
  QC = Math.PI * GC,
  ZC = 60;
function KC(n, e) {
  const { wobble: r } = n.options,
    { wobble: o } = n;
  if (!(r != null && r.enable) || !o) return;
  const l = o.angleSpeed * e.factor,
    u = o.moveSpeed * e.factor,
    c = (u * ((n.retina.wobbleDistance ?? qC) * e.factor)) / (Fe / ZC),
    d = QC,
    { position: p } = n;
  ((o.angle += l),
    o.angle > d && (o.angle -= d),
    (p.x += c * Math.cos(o.angle)),
    (p.y += c * Math.abs(Math.sin(o.angle))));
}
const YC = 2,
  XC = Math.PI * YC,
  JC = 360,
  ew = 10,
  tw = 0;
class nw {
  constructor(e) {
    this.container = e;
  }
  init(e) {
    const r = e.options.wobble;
    (r != null && r.enable
      ? (e.wobble = {
          angle: se() * XC,
          angleSpeed: H(r.speed.angle) / JC,
          moveSpeed: H(r.speed.move) / ew,
        })
      : (e.wobble = { angle: 0, angleSpeed: 0, moveSpeed: 0 }),
      (e.retina.wobbleDistance =
        H((r == null ? void 0 : r.distance) ?? tw) *
        this.container.retina.pixelRatio));
  }
  isEnabled(e) {
    var r;
    return (
      !e.destroyed &&
      !e.spawning &&
      !!((r = e.options.wobble) != null && r.enable)
    );
  }
  loadOptions(e, ...r) {
    e.wobble || (e.wobble = new WC());
    for (const o of r) e.wobble.load(o == null ? void 0 : o.wobble);
  }
  update(e, r) {
    this.isEnabled(e) && KC(e, r);
  }
}
async function iw(n, e = !0) {
  (re(n, "3.7.1"),
    await n.addParticleUpdater("wobble", (r) => Promise.resolve(new nw(r)), e));
}
async function rw(n, e = !0) {
  (re(n, "3.7.1"),
    await j8(n, !1),
    await gm(n, !1),
    await jC(n, !1),
    await HC(n, !1),
    await iw(n, !1),
    await IC(n, !1),
    await cm(n, !1),
    await E8(n, !1),
    await X8(n, !1),
    await nm(n, !1),
    await lm(n, !1),
    await MC(n, e));
}
const ow = (n) => {
    const e = n.id ?? "tsparticles";
    return (
      ve.useEffect(() => {
        let r;
        return (
          _3.load({ id: e, url: n.url, options: n.options }).then((o) => {
            var l;
            ((r = o), (l = n.particlesLoaded) == null || l.call(n, o));
          }),
          () => {
            r == null || r.destroy();
          }
        );
      }, [e, n, n.url, n.options]),
      J.jsx("div", { id: e, className: n.className })
    );
  },
  sw = "" + new URL("nuvem1-CaLXjpbj.png", import.meta.url).href,
  lw = "" + new URL("nuvem2-T17cou6V.png", import.meta.url).href,
  aw = "" + new URL("nuvem3-CuV7sYCc.png", import.meta.url).href,
  uw = "" + new URL("nuvem4-lpQQaluW.png", import.meta.url).href,
  cw = "" + new URL("RAIO-CodxnePx.png", import.meta.url).href,
  fw = "" + new URL("SOL-DShCmwM-.png", import.meta.url).href,
  dw = "" + new URL("FOG-CklRw2HM.png", import.meta.url).href,
  hw = `<svg xmlns="http://www.w3.org/2000/svg" width="76" height="119" viewBox="0 0 76 119" fill="none">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M69.6161 59.3821L38.8385 0.536538C38.4642 -0.179056 37.4399 -0.17879 37.066 0.536999L6.47026 59.1086C2.38504 65.1625 0 72.4583 0 80.3111C0 101.271 16.9916 118.263 37.9518 118.263C58.912 118.263 75.9036 101.271 75.9036 80.3111C75.9036 72.5761 73.5896 65.3816 69.6161 59.3821Z" fill="url(#paint0_linear_4_5)"/>
    <defs>
      <linearGradient id="paint0_linear_4_5" x1="38.4578" y1="118.424" x2="37.9517" y2="3.93701e-06" gradientUnits="userSpaceOnUse">
        <stop offset="0.0001" stop-color="#D9D9D9"/>
        <stop offset="0.0002" stop-color="#1851E4"/>
        <stop offset="0.276042" stop-color="#0E4BE9" stop-opacity="0.67"/>
        <stop offset="0.399971" stop-color="#0A49EC" stop-opacity="0.44"/>
        <stop offset="0.636496" stop-color="#0546EE" stop-opacity="0.4"/>
        <stop offset="1" stop-color="#6284DB" stop-opacity="0.1"/>
      </linearGradient>
    </defs>
  </svg>`,
  pw = `<svg width="1050" height="1051" viewBox="0 0 1050 1051" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M199.483 855.829C193.893 862.209 188.303 868.579 181.943 875.849C183.283 879.449 184.143 885.069 181.193 890.639C179.263 894.279 176.633 897.189 172.933 899.049C166.363 902.349 157.643 900.579 152.483 894.919C146.423 888.269 146.753 879.539 150.843 872.669C155.193 865.359 163.293 863.549 174.473 867.049C181.423 860.049 188.493 852.939 196.343 845.029C193.733 844.889 192.353 844.789 190.983 844.739C184.273 844.469 177.553 844.229 170.843 843.939C169.573 843.889 168.293 843.799 167.053 843.529C163.423 842.729 161.313 840.619 161.283 837.939C161.253 835.229 163.243 833.049 166.923 832.259C169.033 831.809 171.243 831.679 173.413 831.709C183.583 831.839 193.753 831.939 203.913 832.339C207.273 832.469 209.733 831.609 212.103 829.169C220.203 820.829 228.503 812.699 236.723 804.469C237.473 803.719 238.143 802.899 239.503 801.399C234.023 800.629 229.253 800.179 224.583 799.249C210.003 796.349 195.443 793.329 180.903 790.199C178.473 789.679 176.083 788.579 173.913 787.319C171.933 786.169 170.823 784.179 171.583 781.739C172.313 779.379 174.123 778.069 176.513 778.199C181.943 778.499 187.413 778.699 192.773 779.569C209.433 782.289 226.043 785.279 242.663 788.229C245.323 788.699 247.923 789.539 250.143 790.099C262.083 778.059 273.823 766.239 285.873 754.079C282.823 753.129 279.463 751.939 276.033 751.029C253.033 744.879 229.643 740.689 206.163 736.859C201.733 736.139 197.443 734.549 193.133 733.229C191.953 732.869 190.853 732.099 189.853 731.329C188.093 729.979 186.113 728.149 187.133 725.949C187.923 724.239 190.013 722.349 191.793 722.019C195.843 721.289 200.143 720.809 204.183 721.389C231.863 725.349 259.403 730.089 286.313 737.909C288.533 738.549 290.823 738.949 293.723 739.609C293.923 737.219 294.063 735.309 294.253 733.399C295.283 722.74 296.083 712.059 297.433 701.439C298.303 694.569 300.063 693.309 306.723 692.089C323.323 689.039 339.893 685.839 356.503 682.869C359.133 682.399 360.623 680.769 362.253 679.109C381.623 659.429 400.953 639.729 420.343 620.069C433.993 606.229 447.713 592.469 461.403 578.669C465.413 574.629 465.473 574.299 462.423 569.479C461.553 568.099 460.513 566.829 459.563 565.499C459.043 564.759 458.543 563.999 458.023 563.229C455.953 563.979 454.423 564.459 452.963 565.089C442.113 569.709 431.303 574.449 420.403 578.959C416.903 580.409 414.183 582.389 412.213 585.679C403.193 600.799 394.043 615.839 384.943 630.909C383.913 632.609 383.033 634.459 381.753 635.949C378.973 639.189 374.743 639.829 371.443 637.749C368.313 635.779 367.033 632.019 368.343 628.189C368.803 626.829 369.583 625.569 370.303 624.319C375.863 614.739 381.443 605.179 387.003 595.599C387.323 595.049 387.483 594.399 388.023 593.029C385.843 593.849 384.363 594.359 382.923 594.969C372.063 599.569 361.243 604.269 350.333 608.759C347.283 610.009 345.313 611.74 344.063 614.919C339.213 627.24 334.063 639.439 329.003 651.679C328.593 652.679 328.163 653.709 327.553 654.589C325.533 657.519 321.923 658.559 318.923 657.179C316.173 655.909 314.563 652.729 315.263 649.419C315.593 647.839 316.293 646.329 316.953 644.839C319.973 638.039 323.043 631.259 326.073 624.459C326.803 622.829 327.453 621.169 328.453 618.759C326.633 619.269 325.463 619.469 324.403 619.909C316.023 623.399 307.693 626.989 299.293 630.429C296.803 631.449 295.193 632.929 294.023 635.469C290.003 644.209 285.723 652.819 281.453 661.439C280.663 663.039 279.663 664.639 278.413 665.879C276.243 668.029 273.253 668.38 270.873 667.169C268.373 665.889 266.703 662.819 267.453 659.809C268.003 657.559 269.113 655.419 270.223 653.359C272.363 649.389 274.673 645.509 276.803 641.779C276.483 641.249 276.423 641.079 276.303 640.979C276.183 640.869 275.963 640.739 275.843 640.779C274.303 641.309 272.753 641.799 271.253 642.439C256.563 648.659 241.883 654.899 227.133 661.159C225.523 677.5 217.253 687.409 203.953 688.789C192.353 689.989 181.003 682.549 177.373 671.359C173.483 659.359 178.443 647.269 189.903 640.789C201.413 634.279 212.833 637.179 223.593 649.519C239.623 642.589 255.723 635.619 272.713 628.279C270.863 627.319 269.753 626.649 268.563 626.149C263.713 624.119 258.773 622.289 254.013 620.069C251.923 619.099 250.053 617.509 248.353 615.909C246.823 614.459 246.313 612.5 247.303 610.409C248.303 608.31 250.193 607.589 252.263 607.779C254.223 607.959 256.203 608.479 258.063 609.149C267.283 612.449 276.523 615.729 285.653 619.289C288.573 620.429 291.043 620.579 293.943 619.269C303.703 614.869 313.573 610.7 323.383 606.419C324.343 606 325.253 605.439 326.903 604.569C322.073 602.279 317.873 600.279 313.673 598.299C307.933 595.589 302.093 593.059 296.473 590.109C293.303 588.449 290.343 586.269 287.563 583.989C286.003 582.709 285.173 580.699 286.543 578.619C287.863 576.639 289.803 576.459 291.853 577.129C297.543 578.999 303.273 580.749 308.863 582.889C319.713 587.039 330.493 591.359 341.243 595.739C343.553 596.679 345.553 597.019 347.953 595.969C362.573 589.549 377.263 583.259 391.913 576.909C392.693 576.569 393.393 576.069 394.883 575.209C392.693 574.469 391.273 573.919 389.803 573.509C377.563 570.119 365.313 566.789 353.073 563.379C350.103 562.549 347.183 561.539 344.293 560.479C342.773 559.919 341.303 559.159 339.903 558.319C337.593 556.939 335.893 555.099 336.553 552.109C337.073 549.759 339.083 548.519 342.523 548.439C343.973 548.409 345.433 548.519 346.863 548.709C367.463 551.399 387.533 556.399 406.973 563.619C413.183 565.929 418.453 566.239 424.443 563.059C431.153 559.499 438.343 556.819 445.423 553.989C448.753 552.659 450.273 550.409 450.453 546.999C450.773 541.059 449.753 535.459 446.503 530.299C445.293 530.179 444.223 529.989 443.153 529.979C394.653 529.629 346.163 529.319 297.663 528.929C294.463 528.899 291.713 529.529 288.993 531.329C276.563 539.519 263.973 547.459 251.543 555.639C243.373 561.029 239.843 558.939 235.093 554.609C226.263 546.539 217.113 538.819 207.603 530.519C206.123 531.639 204.323 532.769 202.803 534.189C183.453 552.339 164.543 570.919 147.123 590.969C143.793 594.809 140.253 598.479 136.663 602.069C135.143 603.589 133.333 604.889 131.463 605.969C129.443 607.129 127.253 607.169 125.433 605.399C123.773 603.779 123.763 601.679 124.693 599.839C125.993 597.259 127.423 594.659 129.253 592.449C137.933 581.959 146.463 571.319 155.643 561.279C164.333 551.769 173.773 542.949 182.883 533.809C184.123 532.559 185.333 531.279 187.173 529.359C185.163 529.179 183.993 528.989 182.833 528.989C169.573 528.969 156.313 529.039 143.053 528.949C140.343 528.929 138.173 529.259 136.653 531.899C135.883 533.239 134.343 534.169 133.063 535.179C121.783 544.059 110.733 553.199 100.723 563.539C97.8227 566.539 94.7027 569.329 91.5127 572.029C85.9927 576.699 82.8728 577.589 80.5828 575.449C78.2028 573.209 79.2227 569.809 84.2627 564.209C87.0527 561.109 89.9728 558.099 93.0828 555.319C101.203 548.059 109.463 540.949 117.663 533.769C119.003 532.589 120.313 531.379 122.233 529.649C120.323 529.389 119.163 529.109 118.013 529.099C107.843 529.069 97.6727 529.129 87.4927 529.059C83.9027 529.039 80.9328 529.879 78.0928 532.399C70.4828 539.139 62.5827 545.549 54.7427 552.019C53.3627 553.159 51.8228 554.459 50.1628 554.839C48.6228 555.189 46.5327 554.859 45.2227 554.009C43.5627 552.929 43.6128 550.819 44.6028 549.079C45.4028 547.669 46.2828 546.249 47.3828 545.069C51.2128 540.949 55.1527 536.929 59.0427 532.859C59.9727 531.879 60.8428 530.849 62.3528 529.169H35.4727C29.4927 539.489 22.2529 543.349 13.1829 540.969C5.52287 538.959 0.132801 532.159 0.362801 524.069C0.592801 515.679 4.72265 509.759 14.2026 506.609C22.4926 503.849 29.4026 508.049 35.6926 518.859C45.6226 518.859 55.5428 518.859 66.3528 518.859C65.0028 517.229 64.2027 516.149 63.2927 515.179C58.7127 510.259 54.0227 505.449 49.5527 500.429C48.0227 498.709 46.5127 496.629 45.9627 494.469C45.5527 492.849 46.1227 490.219 47.2827 489.149C48.4427 488.079 51.1829 487.649 52.6729 488.269C55.2629 489.349 57.7027 491.179 59.7127 493.189C66.7627 500.259 73.7327 507.429 80.4627 514.799C83.1227 517.709 85.8328 519.039 89.8728 518.959C102.203 518.699 114.533 518.859 128.033 518.859C126.573 516.779 125.673 515.359 124.643 514.049C113.573 500.069 103.553 485.389 94.8027 469.839C93.7327 467.949 92.6726 466.009 91.9526 463.969C90.8026 460.709 91.6529 458.069 93.9329 456.749C96.0729 455.509 98.3427 455.909 100.773 458.349C102.813 460.399 104.793 462.579 106.463 464.939C118.493 481.999 130.483 499.089 142.363 516.259C143.503 517.899 144.413 518.959 146.553 518.949C161.813 518.879 177.063 518.929 192.323 518.909C192.793 518.909 193.273 518.619 194.303 518.289C192.963 515.559 191.943 512.849 190.413 510.489C178.753 492.519 167.033 474.599 155.253 456.709C152.763 452.919 149.673 449.499 147.403 445.589C145.413 442.189 143.953 438.429 142.703 434.669C141.963 432.449 142.013 429.849 144.273 428.209C146.573 426.549 149.013 427.489 150.843 428.939C154.083 431.519 157.523 434.119 159.963 437.399C176.313 459.419 192.203 481.779 205.503 505.839C206.813 508.209 208.253 510.519 209.953 513.409C211.673 511.969 213.133 510.729 214.613 509.509C222.713 502.789 230.673 495.879 238.973 489.409C245.133 484.609 247.173 484.939 253.543 489.339C267.273 498.839 281.023 508.339 294.893 517.639C296.513 518.729 298.983 518.919 301.053 518.919C323.393 518.849 345.733 518.639 368.073 518.489C392.413 518.319 416.753 518.169 441.093 518.019C443.253 518.009 445.403 518.019 448.243 518.019C449.183 513.369 450.063 509.049 450.983 504.509C443.933 501.679 437.553 499.119 431.183 496.559C424.783 493.989 418.373 491.449 412.003 488.809C409.413 487.729 406.953 487.499 404.093 487.999C386.363 491.129 369.053 495.919 351.773 500.849C349.853 501.399 347.943 502.089 345.983 502.319C341.883 502.799 338.203 500.299 337.133 496.599C336.063 492.929 337.933 489.049 341.783 487.209C342.913 486.669 344.173 486.369 345.393 486.049C356.263 483.169 367.153 480.299 378.023 477.419C378.503 477.289 378.943 476.989 380.043 476.449C378.633 475.649 377.693 474.969 376.653 474.549C365.043 469.849 353.403 465.249 341.823 460.479C339.303 459.439 337.133 459.329 334.573 460.429C322.233 465.709 309.823 470.819 297.433 475.969C296.263 476.459 295.073 476.979 293.843 477.199C290.833 477.749 287.903 476.249 286.533 473.619C285.143 470.959 285.573 467.829 288.063 465.709C289.543 464.449 291.403 463.539 293.233 462.829C300.323 460.039 307.473 457.399 314.593 454.679C316.253 454.049 317.873 453.329 320.383 452.289C318.453 451.349 317.293 450.709 316.083 450.219C308.023 446.929 299.903 443.749 291.893 440.339C289.063 439.139 286.593 438.899 283.583 440.029C274.753 443.339 265.793 446.309 256.853 449.299C255.003 449.919 252.973 450.289 251.033 450.269C248.263 450.239 246.173 448.709 245.263 446.049C244.363 443.419 244.903 440.809 247.103 439.129C248.923 437.749 251.133 436.729 253.333 436.029C258.133 434.509 263.033 433.289 267.963 430.859C251.613 424.189 235.263 417.519 218.443 410.659C212.983 416.259 206.023 419.849 197.573 419.469C191.623 419.199 186.223 417.199 181.723 413.099C173.053 405.209 170.833 392.489 176.373 382.229C182.293 371.249 194.013 366.499 206.603 369.979C219.113 373.439 225.153 383.559 224.333 400.039C240.563 406.479 256.883 412.959 274.123 419.799C273.333 417.609 272.873 416.169 272.303 414.769C270.323 409.899 268.123 405.109 266.393 400.149C265.643 397.999 265.363 395.449 265.713 393.209C265.943 391.729 267.423 389.779 268.773 389.329C270.153 388.869 272.493 389.509 273.613 390.549C275.283 392.089 276.463 394.289 277.463 396.399C281.593 405.089 285.723 413.789 289.513 422.619C290.773 425.549 292.483 427.279 295.413 428.399C306.253 432.539 317.023 436.859 328.483 441.379C328.153 439.659 328.083 438.499 327.713 437.439C324.553 428.549 321.173 419.729 318.203 410.769C316.963 407.029 316.373 403.039 315.833 399.119C315.553 397.069 316.373 395.039 318.733 394.469C321.003 393.919 322.623 395.119 323.593 397.069C326.973 403.899 330.433 410.699 333.573 417.639C337.683 426.739 341.573 435.939 345.413 445.149C346.373 447.449 347.553 449.119 350.003 450.079C365.053 455.949 380.043 461.949 395.063 467.889C395.693 468.139 396.363 468.259 397.773 468.649C396.923 466.799 396.443 465.539 395.783 464.369C389.633 453.459 383.403 442.589 377.313 431.649C375.283 428.009 373.473 424.239 371.763 420.439C371.103 418.989 370.813 417.309 370.653 415.699C370.443 413.549 371.193 411.429 373.343 410.889C374.883 410.499 377.083 410.699 378.333 411.579C380.353 413.009 381.983 415.099 383.523 417.099C395.663 432.839 405.843 449.829 414.093 467.859C417.183 474.619 421.033 479.099 428.293 481.259C435.043 483.269 441.583 486.169 447.983 489.159C452.243 491.149 455.533 490.049 458.233 486.989C460.723 484.159 462.933 480.979 464.703 477.649C466.803 473.699 466.543 473.409 463.313 470.139C447.223 453.859 431.103 437.619 415.023 421.329C397.293 403.359 379.583 385.359 361.913 367.319C359.563 364.919 357.083 363.309 353.643 362.619C339.063 359.679 324.563 356.359 309.993 353.319C302.333 351.729 300.023 349.149 299.573 341.219C298.923 329.619 298.203 318.019 297.483 306.429C297.453 305.919 297.173 305.419 296.863 304.459C295.043 304.249 293.123 303.889 291.183 303.809C263.573 302.679 235.983 302.779 208.413 304.739C204.613 305.009 200.793 305.099 196.983 305.109C195.183 305.109 193.353 304.889 191.583 304.529C187.843 303.759 186.023 302.089 186.043 299.539C186.073 296.409 188.293 295.189 190.853 294.439C192.593 293.929 194.373 293.539 196.153 293.249C213.223 290.509 230.443 289.499 247.713 289.289C257.883 289.159 268.053 289.379 278.223 289.429C279.623 289.429 281.023 289.429 283.423 289.429C282.173 287.929 281.593 287.119 280.893 286.419C271.393 276.909 261.833 267.459 252.393 257.889C250.483 255.949 248.643 255.159 245.763 255.249C241.263 255.389 236.743 254.439 232.213 254.199C217.533 253.409 202.843 252.779 188.163 251.989C185.283 251.829 182.393 251.379 179.563 250.759C177.333 250.269 175.443 249.009 175.473 246.359C175.503 243.699 177.453 242.499 179.703 242.129C183.093 241.569 186.553 240.949 189.963 241.089C203.563 241.649 217.153 242.509 230.753 243.229C232.513 243.319 234.283 243.239 236.733 243.239C235.723 241.889 235.133 240.859 234.323 240.049C227.023 232.709 219.663 225.429 212.383 218.059C210.253 215.899 207.973 214.719 204.803 214.489C194.303 213.729 183.833 212.659 173.353 211.619C171.573 211.439 169.613 211.189 168.143 210.299C166.943 209.579 165.693 207.859 165.673 206.569C165.663 205.289 166.913 203.589 168.093 202.819C169.353 201.989 171.173 201.789 172.773 201.719C178.753 201.459 184.743 201.369 190.733 201.219C191.923 201.189 193.123 201.219 195.663 201.219C188.763 194.209 182.723 188.089 176.753 182.029C163.263 184.579 155.563 181.869 151.413 173.189C148.173 166.429 149.963 157.979 155.793 152.819C162.343 147.029 170.663 146.999 178.023 151.459C185.333 155.879 187.003 163.969 183.443 174.939C190.523 181.929 197.663 188.979 204.803 196.019C205.233 195.849 205.663 195.679 206.093 195.509C206.093 190.489 206.003 185.479 206.123 180.459C206.213 176.649 206.493 172.849 206.863 169.049C207.003 167.639 207.223 165.939 208.083 164.959C209.293 163.579 211.133 161.899 212.703 161.909C214.293 161.909 216.633 163.489 217.273 164.969C218.383 167.539 218.873 170.579 218.863 173.409C218.833 183.389 218.673 193.389 218.163 203.359C217.953 207.539 219.153 210.499 222.173 213.379C229.933 220.769 237.373 228.489 244.963 236.059C246.083 237.179 247.303 238.199 249.193 239.929C249.693 236.389 250.153 233.629 250.483 230.849C252.493 213.869 255.863 197.159 260.513 180.709C261.103 178.629 261.893 176.549 262.973 174.689C264.253 172.469 266.353 171.349 268.993 172.179C271.373 172.929 272.563 174.839 272.423 177.179C272.133 182.429 271.893 187.719 271.053 192.899C268.393 209.199 265.463 225.459 262.633 241.739C262.573 242.099 262.583 242.499 262.423 242.809C259.023 249.539 262.133 253.949 267.083 258.519C275.623 266.389 283.593 274.889 291.813 283.099C293.063 284.349 294.403 285.509 296.293 287.269C297.913 281.699 299.453 276.879 300.703 271.989C306.323 249.979 310.243 227.639 313.923 205.239C314.643 200.839 316.393 196.559 318.023 192.369C318.633 190.789 320.053 189.339 321.443 188.269C323.433 186.739 325.813 187.109 327.083 189.279C328.153 191.089 328.783 193.259 329.143 195.349C330.343 202.299 328.643 209.089 327.563 215.889C323.593 240.819 318.953 265.619 311.793 289.869C311.433 291.069 311.253 292.329 310.863 294.139C316.623 294.579 322.133 294.919 327.633 295.449C334.493 296.099 341.373 296.739 348.203 297.689C355.853 298.749 357.283 300.499 358.603 307.909C361.533 324.349 364.553 340.769 367.763 357.149C368.143 359.079 369.733 360.979 371.213 362.439C387.463 378.559 403.813 394.569 420.103 410.649C437.293 427.619 454.443 444.629 471.623 461.619C472.903 462.879 474.233 464.089 476.073 465.829C479.843 463.389 483.563 460.979 487.543 458.399C485.873 454.519 484.453 451.209 483.033 447.899C479.113 438.719 475.103 429.569 471.313 420.329C470.013 417.159 468.183 414.739 465.233 412.969C450.143 403.909 435.093 394.779 420.033 385.659C418.173 384.529 416.163 383.569 414.533 382.179C411.353 379.469 410.753 375.099 412.823 371.839C414.783 368.759 418.623 367.469 422.443 368.789C423.793 369.259 425.043 370.069 426.293 370.789C435.873 376.349 445.433 381.929 455.013 387.489C455.573 387.809 456.233 387.949 457.563 388.429C456.723 386.279 456.193 384.809 455.573 383.369C450.953 372.509 446.233 361.689 441.753 350.779C440.493 347.719 438.783 345.749 435.613 344.489C423.303 339.609 411.103 334.469 398.873 329.409C397.713 328.929 396.503 328.429 395.513 327.679C392.953 325.749 392.083 322.689 393.113 319.939C394.233 316.949 397.153 315.089 400.493 315.649C402.433 315.979 404.323 316.759 406.133 317.559C412.773 320.489 419.373 323.529 425.993 326.489C427.603 327.209 429.263 327.809 431.723 328.799C431.173 326.859 430.973 325.699 430.523 324.639C427.023 316.269 423.413 307.939 419.973 299.529C419.023 297.199 417.653 295.669 415.333 294.589C406.623 290.529 397.993 286.279 389.343 282.079C388.363 281.609 387.373 281.129 386.483 280.519C383.063 278.139 381.823 274.669 383.213 271.619C384.713 268.349 388.403 266.959 392.543 268.339C394.243 268.899 395.823 269.869 397.403 270.749C400.413 272.429 403.363 274.219 406.383 275.889C407.263 276.379 408.263 276.649 410.403 277.479C403.123 260.159 396.273 243.879 389.413 227.559C373.053 225.789 363.203 217.719 361.823 204.909C360.523 192.769 367.773 181.429 379.163 177.769C391.153 173.929 403.313 178.919 409.733 190.329C416.223 201.869 413.403 212.999 401.013 224.049C407.943 240.069 414.903 256.169 422.373 273.439C423.433 270.989 424.103 269.479 424.753 267.969C426.813 263.139 428.723 258.229 431.003 253.499C431.923 251.599 433.373 249.699 435.083 248.539C436.353 247.669 438.753 247.309 440.053 247.949C441.323 248.579 442.523 250.739 442.543 252.239C442.573 254.699 441.883 257.269 441.043 259.639C437.813 268.699 434.333 277.669 431.123 286.739C430.503 288.489 429.943 290.809 430.573 292.359C435.253 303.749 440.253 315.009 445.483 327.079C446.503 325.519 447.233 324.639 447.713 323.629C451.613 315.429 455.413 307.189 459.363 299.019C460.783 296.089 462.413 293.249 464.193 290.519C465.053 289.189 466.303 287.879 467.693 287.189C468.833 286.619 470.873 286.409 471.723 287.069C472.783 287.889 473.463 289.739 473.523 291.169C473.583 292.719 472.833 294.339 472.253 295.859C466.533 310.959 460.863 326.089 454.963 341.119C453.823 344.019 453.643 346.419 454.943 349.329C460.973 362.939 466.783 376.639 472.703 390.309C473.313 391.719 474.103 393.059 475.273 395.339C476.143 392.749 476.773 391.129 477.233 389.459C480.543 377.569 483.753 365.659 487.133 353.789C488.223 349.959 489.563 346.189 491.063 342.499C491.723 340.869 492.833 339.259 494.143 338.099C497.023 335.529 500.803 336.719 501.693 340.549C502.173 342.599 501.983 344.879 501.733 347.009C499.253 368.029 493.883 388.379 486.653 408.209C484.603 413.839 484.223 418.629 487.093 424.129C490.603 430.869 493.413 438.009 496.113 445.129C497.823 449.639 501.003 451.189 505.343 451.129C507.323 451.099 509.303 450.689 511.263 450.339C519.893 448.769 520.473 448.029 520.533 439.589C520.813 393.089 521.093 346.589 521.473 300.089C521.513 295.609 520.833 291.689 518.213 287.809C510.293 276.079 502.713 264.109 495.063 252.199C493.893 250.379 492.793 248.459 492.053 246.439C490.693 242.779 492.173 239.769 494.653 237.019C502.783 227.969 510.853 218.869 518.943 209.779C519.293 209.389 519.513 208.889 520.073 207.989C518.823 206.409 517.613 204.639 516.173 203.099C497.793 183.469 478.893 164.359 458.563 146.709C454.863 143.499 451.303 140.099 447.923 136.569C446.323 134.899 444.883 132.859 444.083 130.719C442.683 126.959 446.003 123.499 449.763 124.909C452.763 126.039 455.713 127.749 458.163 129.829C470.643 140.369 483.133 150.909 495.243 161.869C502.773 168.679 509.663 176.209 516.763 183.489C517.873 184.629 518.563 186.169 519.443 187.529C519.923 187.229 520.413 186.929 520.893 186.629C521.063 185.489 521.383 184.349 521.393 183.209C521.413 169.769 521.373 156.329 521.393 142.889C521.393 140.609 521.153 138.729 518.883 137.339C517.403 136.429 516.323 134.799 515.203 133.389C506.303 122.119 497.153 111.089 486.833 101.059C483.713 98.0294 480.843 94.7194 478.003 91.4194C476.713 89.9194 475.643 88.1894 474.693 86.4494C473.673 84.5794 473.543 82.5894 475.213 80.9294C476.933 79.2194 478.983 79.4594 480.693 80.6994C483.763 82.9294 486.993 85.1093 489.543 87.8693C498.423 97.4593 507.053 107.279 515.763 117.029C517.193 118.629 518.573 120.289 520.523 122.569C520.863 120.719 521.243 119.599 521.243 118.479C521.283 107.949 521.233 97.4093 521.283 86.8693C521.303 83.8393 520.473 81.3793 518.393 78.9993C511.703 71.3393 505.243 63.4894 498.773 55.6494C497.513 54.1194 496.473 52.3894 495.513 50.6494C494.503 48.8394 494.803 46.8294 496.433 45.7594C497.623 44.9794 499.533 44.6994 500.943 45.0194C502.433 45.3594 503.853 46.4994 505.033 47.5794C509.053 51.2494 513.013 54.9894 516.883 58.8194C518.023 59.9394 518.783 61.4394 519.723 62.7694C520.203 62.5094 520.673 62.2394 521.153 61.9794V35.7694C516.523 33.5794 511.983 30.3995 510.063 24.6095C508.783 20.7195 508.433 16.8294 509.713 12.8494C512.143 5.28944 519.023 0.659427 527.283 0.959427C535.653 1.25943 541.993 7.2494 544.083 15.5594C546.163 23.8294 541.863 30.6494 531.513 36.0694V66.6193C533.033 65.5293 534.033 64.9694 534.853 64.2094C539.773 59.6294 544.603 54.9594 549.573 50.4394C551.163 48.9894 553.013 47.7694 554.893 46.7094C556.933 45.5594 559.123 45.5794 560.993 47.1994C563.093 49.0094 563.203 51.4594 562.133 53.6794C561.123 55.7594 559.703 57.7594 558.063 59.3894C550.703 66.6694 543.323 73.9294 535.693 80.9294C532.783 83.5994 531.493 86.3294 531.573 90.3494C531.833 102.679 531.663 115.019 531.663 128.559C533.873 126.969 535.413 125.949 536.853 124.799C550.843 113.739 565.533 103.739 581.103 95.0394C583.153 93.8994 585.323 92.8994 587.533 92.1494C589.793 91.3794 591.953 92.0193 593.353 93.9893C594.923 96.2093 594.443 98.4993 592.793 100.499C591.993 101.469 591.053 102.359 590.063 103.149C586.093 106.319 582.183 109.589 578.053 112.539C565.943 121.209 553.763 129.769 541.553 138.299C538.443 140.479 535.133 142.389 531.723 144.539V194.819C533.663 193.989 535.303 193.499 536.733 192.649C545.173 187.659 553.763 182.889 561.913 177.469C575.223 168.629 588.173 159.249 601.403 150.299C605.123 147.779 609.283 145.909 613.273 143.809C614.063 143.399 614.983 143.139 615.873 143.049C618.223 142.799 620.713 142.449 622.283 144.839C623.833 147.199 622.923 149.639 621.443 151.419C618.573 154.879 615.663 158.529 612.093 161.169C589.763 177.719 567.063 193.739 542.633 207.109C540.903 208.059 539.253 209.149 537.163 210.419C538.213 211.759 539.013 212.869 539.913 213.909C544.653 219.419 549.473 224.849 554.133 230.419C556.813 233.619 559.363 236.939 561.753 240.359C565.513 245.739 565.413 247.859 561.753 253.169C554.003 264.369 546.273 275.579 538.543 286.789C536.583 289.629 534.403 292.349 532.833 295.389C531.893 297.189 531.603 299.499 531.603 301.579C531.603 319.559 531.733 337.539 531.843 355.529C532.023 384.589 532.223 413.649 532.413 442.709C532.453 448.659 532.773 449.109 538.513 450.239C540.803 450.689 543.143 450.939 545.673 451.309C546.423 449.829 547.153 448.619 547.673 447.309C552.343 435.689 556.943 424.039 561.673 412.439C562.743 409.809 562.963 407.339 562.463 404.519C559.363 386.969 554.683 369.809 549.753 352.709C549.203 350.789 548.523 348.879 548.253 346.919C547.643 342.409 549.993 338.729 553.973 337.609C557.913 336.499 561.773 338.519 563.513 342.819C564.253 344.659 564.613 346.649 565.133 348.569C567.943 359.039 570.753 369.499 573.813 380.889C574.893 378.909 575.673 377.759 576.183 376.509C580.813 365.069 585.333 353.579 590.053 342.169C591.113 339.609 591.063 337.439 589.983 334.909C584.723 322.559 579.623 310.149 574.463 297.749C574.113 296.909 573.713 296.079 573.503 295.209C572.623 291.709 574.113 288.249 577.023 286.879C579.983 285.489 583.663 286.439 585.623 289.489C586.883 291.449 587.693 293.709 588.533 295.909C591.603 303.849 594.603 311.809 597.933 320.559C598.933 318.959 599.693 318.069 600.113 317.039C603.553 308.639 606.883 300.199 610.373 291.819C611.403 289.339 611.613 287.159 610.643 284.519C607.383 275.669 604.373 266.719 601.393 257.769C600.723 255.749 600.293 253.549 600.273 251.429C600.253 248.649 601.853 246.589 604.493 245.659C607.143 244.719 609.763 245.389 611.373 247.579C612.833 249.559 613.863 251.969 614.623 254.329C616.093 258.929 617.243 263.629 618.523 268.289C618.913 268.289 619.303 268.299 619.683 268.309C626.343 251.959 633.003 235.619 639.823 218.909C634.353 213.419 630.753 206.679 631.033 198.369C631.223 192.779 632.923 187.679 636.483 183.269C643.783 174.229 656.623 171.229 667.003 176.149C678.123 181.419 683.493 192.439 680.953 205.149C679.573 212.049 675.903 217.499 669.903 221.329C663.923 225.139 657.353 225.639 650.593 224.399C643.943 241.209 637.493 257.499 630.633 274.819C633.413 273.659 635.153 272.919 636.913 272.209C641.283 270.439 645.633 268.649 650.033 266.949C651.203 266.499 652.483 266.239 653.733 266.079C657.943 265.539 660.293 266.439 661.293 268.839C662.373 271.449 661.203 274.229 657.273 276.169C647.683 280.919 638.003 285.509 628.213 289.829C625.143 291.179 623.233 292.849 622.043 296.039C617.973 306.879 613.593 317.609 609.033 329.139C611.063 328.629 612.403 328.409 613.673 327.949C622.213 324.899 630.693 321.649 639.293 318.769C643.033 317.519 647.003 316.829 650.913 316.219C653.173 315.869 655.383 316.649 656.043 319.229C656.703 321.829 655.003 323.309 652.943 324.339C647.263 327.179 641.623 330.129 635.833 332.719C625.723 337.239 615.523 341.529 605.343 345.879C603.323 346.749 601.533 347.599 600.623 349.949C594.623 365.339 588.473 380.669 582.413 396.039C582.243 396.469 582.393 397.029 582.393 397.959C583.733 397.359 584.873 396.959 585.903 396.369C596.813 390.219 607.683 383.989 618.623 377.899C622.423 375.789 626.353 373.889 630.313 372.089C631.763 371.429 633.473 371.059 635.063 371.049C639.413 371.009 641.673 375.089 639.093 378.599C637.523 380.749 635.293 382.479 633.153 384.139C617.263 396.389 600.073 406.569 581.893 414.909C575.653 417.769 571.623 421.369 569.543 427.989C567.323 435.069 564.273 441.909 561.263 448.709C559.613 452.449 560.323 455.429 562.983 458.109C564.633 459.769 566.473 461.299 568.403 462.629C576.053 467.899 576.253 467.809 582.903 461.249C616.253 428.329 649.613 395.409 683.023 362.549C685.573 360.039 687.233 357.419 687.963 353.809C690.873 339.399 694.153 325.079 697.193 310.689C698.923 302.469 701.333 300.389 709.603 299.899C721.543 299.189 733.483 298.309 745.963 297.459C746.193 295.999 746.573 294.459 746.643 292.909C747.803 265.309 747.883 237.709 745.813 210.139C745.463 205.439 745.463 200.699 745.523 195.979C745.543 194.019 745.983 192.019 746.523 190.109C747.103 188.059 748.493 186.619 750.783 186.479C753.383 186.319 754.893 187.899 755.623 190.099C756.423 192.499 757.043 194.979 757.433 197.479C760.193 215.289 761.173 233.229 761.183 251.229C761.183 260.859 761.043 270.479 760.973 280.109C760.973 280.969 761.053 281.839 761.133 283.479C762.563 282.429 763.583 281.859 764.383 281.059C773.903 271.569 783.363 262.019 792.913 252.559C794.703 250.789 795.243 249.099 795.253 246.429C795.273 240.109 796.353 233.789 796.763 227.459C797.313 218.949 797.643 210.419 798.053 201.899C798.333 196.099 798.413 190.279 798.903 184.489C799.093 182.209 799.743 179.779 800.883 177.809C802.523 174.959 805.783 175.109 807.453 177.949C808.253 179.309 808.773 180.999 808.853 182.569C809.173 188.359 809.653 194.179 809.363 199.959C808.793 211.559 807.753 223.139 806.923 234.729C806.873 235.439 806.923 236.169 806.923 237.479C808.203 236.569 809.253 236.009 810.063 235.199C817.543 227.779 824.933 220.269 832.443 212.889C834.773 210.609 835.883 208.129 836.123 204.799C836.893 194.119 837.953 183.459 839.083 172.809C839.593 168.029 841.213 165.979 843.853 165.859C846.703 165.739 848.593 168.159 848.873 173.069C849.193 178.689 849.173 184.319 849.283 189.949C849.313 191.509 849.283 193.069 850.273 195.169C856.383 189.149 862.483 183.139 868.543 177.169C865.903 164.089 868.423 156.499 876.833 152.099C883.553 148.579 892.533 150.249 897.703 156.229C903.393 162.809 903.713 169.979 899.413 177.969C895.303 185.599 887.223 187.409 876.483 184.249C869.003 191.279 861.763 198.079 853.783 205.579C856.003 205.899 857.143 206.159 858.283 206.209C865.543 206.529 872.803 206.719 880.053 207.139C882.003 207.249 884.083 207.669 885.793 208.559C889.823 210.649 889.933 215.589 885.893 217.619C883.723 218.709 881.023 219.169 878.553 219.179C867.843 219.209 857.123 219.079 846.413 218.739C842.903 218.629 840.273 219.429 837.743 222.049C829.073 231.059 820.143 239.829 810.573 249.439C813.283 249.929 815.263 250.409 817.263 250.629C834.803 252.559 852.053 256.009 869.043 260.719C871.463 261.389 873.853 262.369 876.063 263.569C878.163 264.699 879.033 266.769 878.453 269.149C877.853 271.599 875.993 272.869 873.633 272.759C868.563 272.529 863.453 272.339 858.463 271.519C841.273 268.709 824.113 265.669 806.953 262.649C804.473 262.209 802.053 261.409 800.033 260.879C788.103 272.899 776.373 284.719 764.343 296.839C767.183 297.759 770.353 298.949 773.603 299.819C796.603 305.979 819.993 310.199 843.463 314.039C848.063 314.789 852.523 316.449 857.023 317.789C858.043 318.089 858.993 318.729 859.873 319.369C861.843 320.789 864.013 322.649 862.943 325.129C862.213 326.829 860.013 328.649 858.203 328.979C854.153 329.699 849.853 330.189 845.813 329.609C817.593 325.569 789.543 320.589 762.103 312.669C760.403 312.179 758.643 311.859 756.343 311.329C756.063 315.219 755.863 318.629 755.553 322.029C754.773 330.529 753.973 339.019 753.123 347.509C752.983 348.949 752.583 350.359 752.303 351.779C751.493 355.849 748.923 357.949 744.913 358.689C728.313 361.749 711.753 364.999 695.133 367.899C692.013 368.439 689.863 369.799 687.763 371.929C659.113 401.079 630.433 430.189 601.723 459.279C596.253 464.829 590.633 470.229 584.573 476.199C587.163 480.229 589.553 483.949 591.973 487.719C593.803 487.099 595.013 486.779 596.153 486.299C607.843 481.319 619.483 476.229 631.223 471.369C634.113 470.169 636.043 468.259 637.573 465.719C646.683 450.649 655.793 435.589 664.893 420.519C665.833 418.969 666.593 417.289 667.673 415.839C670.453 412.109 674.653 411.039 678.213 412.989C682.043 415.079 683.343 419.399 681.373 423.839C680.793 425.159 679.953 426.369 679.223 427.619C673.843 436.879 668.453 446.139 663.093 455.419C662.773 455.979 662.633 456.629 662.173 457.899C663.613 457.419 664.433 457.199 665.203 456.869C677.063 451.829 688.883 446.699 700.793 441.789C703.403 440.709 704.813 439.059 705.833 436.549C710.873 424.109 716.013 411.709 721.163 399.309C721.713 397.989 722.373 396.639 723.273 395.549C725.103 393.359 728.133 392.679 730.703 393.619C733.273 394.559 735.053 396.969 734.853 399.999C734.723 401.939 734.133 403.929 733.353 405.719C730.393 412.549 727.263 419.299 724.213 426.089C723.403 427.889 722.663 429.729 721.573 432.289C723.343 431.789 724.503 431.589 725.563 431.149C733.933 427.649 742.253 424.019 750.673 420.629C753.403 419.529 755.023 417.839 756.253 415.169C760.193 406.599 764.363 398.129 768.563 389.679C769.433 387.929 770.593 386.209 772.003 384.879C773.993 383.009 776.533 382.589 779.093 383.789C781.683 384.999 783.043 387.309 782.603 389.979C782.173 392.579 781.143 395.169 779.933 397.549C777.823 401.689 775.373 405.659 773.063 409.709C773.323 409.999 773.583 410.279 773.843 410.569C790.123 403.719 806.413 396.859 822.743 389.989C825.213 372.589 833.573 363.009 847.113 362.129C858.803 361.369 869.823 369.199 873.033 380.529C876.463 392.659 871.073 404.589 859.423 410.659C848.073 416.569 836.543 413.419 826.593 401.439C810.533 408.399 794.363 415.399 778.193 422.399C778.203 422.759 778.213 423.129 778.233 423.489C780.523 424.369 782.843 425.169 785.083 426.139C789.403 428.019 793.693 429.969 797.963 431.949C798.773 432.329 799.493 432.929 800.183 433.509C803.013 435.859 803.923 438.279 802.863 440.549C801.813 442.799 799.283 443.849 795.773 442.859C790.893 441.489 786.073 439.859 781.293 438.149C775.313 435.999 769.453 433.539 763.443 431.479C761.703 430.879 759.383 430.539 757.793 431.199C746.733 435.789 735.793 440.659 724.823 445.469C724.523 445.599 724.323 445.979 723.723 446.609C727.543 448.449 731.213 450.249 734.913 451.999C740.983 454.869 747.133 457.579 753.133 460.589C756.033 462.039 758.843 463.799 761.393 465.789C764.143 467.949 764.833 470.549 763.553 472.369C761.853 474.789 759.513 474.319 757.173 473.509C750.153 471.059 743.073 468.759 736.123 466.119C726.963 462.639 717.893 458.939 708.813 455.249C706.733 454.409 704.873 453.819 702.593 454.819C687.463 461.439 672.283 467.939 657.123 474.509C656.663 474.709 656.323 475.179 655.543 475.849C657.283 476.449 658.703 477.019 660.163 477.429C672.403 480.819 684.663 484.149 696.883 487.589C700.373 488.569 703.803 489.769 707.173 491.099C708.833 491.749 710.623 492.639 711.743 493.939C712.803 495.169 713.613 497.109 713.553 498.709C713.463 500.899 711.533 502.189 709.413 502.359C707.083 502.539 704.683 502.459 702.363 502.149C681.773 499.409 661.723 494.329 642.293 487.089C636.583 484.959 631.783 484.879 626.333 487.639C619.383 491.159 612.093 494.029 604.843 496.909C601.293 498.319 599.583 500.749 599.573 504.319C599.563 507.009 599.873 509.749 600.383 512.399C601.953 520.509 602.603 520.949 610.553 520.999C657.593 521.319 704.643 521.629 751.683 522.049C755.453 522.079 758.663 521.329 761.863 519.199C773.953 511.169 786.193 503.349 798.433 495.529C800.393 494.279 802.533 493.189 804.733 492.429C807.993 491.299 810.763 492.659 813.193 494.819C822.013 502.659 830.823 510.509 839.653 518.339C840.443 519.039 841.303 519.659 842.493 520.599C844.253 519.199 846.023 517.989 847.563 516.539C867.203 498.159 886.293 479.249 903.943 458.929C907.393 454.959 911.103 451.199 914.923 447.589C916.443 446.159 918.503 444.979 920.523 444.469C924.013 443.599 926.823 446.499 925.673 449.909C924.713 452.769 923.153 455.599 921.243 457.939C912.623 468.479 904.103 479.129 894.933 489.169C886.123 498.819 876.583 507.799 867.303 517.019C866.043 518.279 864.493 519.249 863.083 520.359C863.303 520.739 863.533 521.129 863.753 521.509C864.723 521.659 865.693 521.949 866.663 521.949C880.283 521.979 893.913 521.939 907.533 521.979C909.803 521.979 911.673 521.779 913.103 519.539C914.133 517.919 915.933 516.779 917.433 515.459C928.063 506.109 938.703 496.769 949.323 487.419C953.413 483.829 957.333 480.029 961.603 476.659C965.123 473.889 967.613 473.779 969.493 475.469C971.523 477.299 971.373 479.919 968.273 483.689C965.173 487.469 961.863 491.139 958.253 494.419C949.793 502.119 941.103 509.569 932.503 517.109C931.153 518.289 929.783 519.439 927.793 521.139C929.433 521.489 930.333 521.849 931.243 521.849C941.783 521.889 952.313 521.809 962.853 521.899C966.283 521.929 969.083 521.059 971.753 518.719C979.263 512.139 986.983 505.799 994.673 499.429C996.203 498.159 997.863 496.989 999.643 496.119C1001.54 495.189 1003.88 495.089 1004.99 497.109C1005.73 498.469 1005.89 500.719 1005.28 502.119C1004.37 504.219 1002.69 506.049 1001.09 507.769C996.913 512.249 992.593 516.599 987.693 521.659H1014.97C1016.84 516.619 1020.51 512.289 1026.44 510.379C1030.34 509.119 1034.28 508.989 1038.22 510.309C1045.51 512.759 1050.17 520.089 1049.62 528.259C1049.04 536.799 1042.97 542.499 1035.11 544.619C1027.08 546.789 1020.14 542.369 1014.52 532.149H983.423C987.613 536.599 991.193 540.359 994.713 544.159C997.183 546.819 999.723 549.429 1001.97 552.279C1005.26 556.429 1005.47 559.769 1002.94 562.009C1000.57 564.109 997.233 563.919 993.633 560.629C988.143 555.619 982.953 550.259 977.723 544.959C974.413 541.599 971.383 537.939 967.973 534.689C966.653 533.429 964.633 532.209 962.913 532.189C949.673 531.979 936.423 532.079 922.043 532.079C923.593 534.269 924.593 535.849 925.753 537.309C936.703 551.149 946.593 565.699 955.273 581.079C956.253 582.809 957.233 584.579 957.933 586.439C959.283 590.019 958.593 592.759 956.223 594.189C953.973 595.539 951.643 595.039 949.003 592.279C946.873 590.049 944.803 587.729 943.013 585.219C930.573 567.789 918.213 550.289 905.403 532.219H855.433C857.493 536.149 859.043 539.779 861.153 543.049C871.703 559.359 882.363 575.599 893.083 591.799C895.983 596.189 899.493 600.199 902.223 604.679C904.373 608.199 905.993 612.099 907.433 615.979C908.333 618.409 908.193 621.199 905.683 622.849C903.393 624.349 900.893 623.439 899.093 621.929C895.653 619.029 892.023 616.109 889.373 612.539C872.713 590.069 856.603 567.199 843.173 542.589C842.313 541.019 841.293 539.549 840.093 537.639C838.493 538.969 837.153 540.089 835.813 541.199C827.573 548.039 819.473 555.059 811.033 561.649C805.013 566.349 802.833 565.989 796.443 561.569C782.713 552.059 768.963 542.569 755.103 533.249C753.613 532.249 751.363 532.029 749.463 532.029C731.113 532.049 712.773 532.169 694.423 532.299C665.723 532.499 637.023 532.729 608.333 532.949C606.523 532.959 604.723 532.949 602.903 532.949C599.953 537.039 599.893 541.579 599.373 546.249C600.803 546.969 602.033 547.689 603.343 548.219C614.963 552.899 626.603 557.509 638.203 562.229C640.813 563.289 643.293 563.479 646.123 562.979C663.853 559.839 681.163 555.049 698.443 550.119C700.183 549.619 701.923 548.999 703.703 548.739C707.823 548.139 711.633 550.429 712.813 554.019C714.113 557.989 712.293 561.969 708.173 563.859C706.873 564.459 705.423 564.759 704.023 565.129C693.503 567.919 682.973 570.689 672.453 573.499C671.823 573.669 671.243 574.049 669.913 574.659C671.993 575.639 673.353 576.359 674.773 576.939C685.873 581.439 697.013 585.859 708.073 590.449C710.763 591.569 713.083 591.639 715.823 590.469C728.153 585.169 740.563 580.069 752.953 574.919C754.123 574.439 755.343 573.969 756.573 573.779C759.323 573.359 762.213 574.859 763.483 577.169C764.863 579.669 764.473 583.189 762.193 585.169C760.723 586.439 758.873 587.379 757.053 588.099C749.963 590.899 742.813 593.529 735.693 596.249C733.883 596.939 732.113 597.749 729.363 598.899C740.473 603.409 750.513 607.559 760.653 611.499C761.993 612.019 763.873 611.789 765.313 611.309C774.433 608.259 783.473 604.99 792.583 601.919C794.613 601.24 796.803 600.719 798.913 600.709C801.913 600.689 804.273 602.679 805.033 605.269C805.843 608.029 804.963 610.529 802.803 612.079C800.803 613.509 798.363 614.459 795.983 615.199C791.373 616.649 786.663 617.809 782.003 620.089C798.423 626.789 814.843 633.479 831.723 640.369C836.973 634.859 843.793 631.319 852.053 631.529C857.793 631.669 863.103 633.449 867.613 637.229C876.693 644.839 879.393 657.949 874.003 668.369C868.213 679.569 856.223 684.539 843.463 681.029C831.053 677.609 825.173 667.689 825.813 650.969C809.583 644.539 793.263 638.069 775.973 631.219C776.803 633.439 777.293 634.849 777.843 636.239C779.903 641.469 782.093 646.639 783.963 651.939C784.603 653.759 784.893 655.969 784.473 657.799C784.123 659.319 782.733 661.239 781.373 661.699C780.003 662.159 777.643 661.539 776.533 660.509C774.863 658.969 773.683 656.769 772.683 654.659C768.563 645.969 764.463 637.259 760.633 628.439C759.383 625.559 757.703 623.739 754.753 622.619C743.903 618.499 733.143 614.169 721.643 609.639C721.993 611.379 722.093 612.539 722.463 613.599C725.483 622.159 728.593 630.689 731.593 639.249C732.553 641.979 733.403 644.769 734.063 647.589C734.433 649.149 734.753 650.959 734.303 652.419C733.833 653.959 732.693 655.709 731.343 656.449C729.543 657.449 727.893 656.099 726.833 654.449C726.053 653.229 725.323 651.959 724.733 650.639C718.233 636.249 711.633 621.899 705.393 607.399C703.843 603.799 701.923 601.539 698.163 600.119C684.413 594.919 670.813 589.349 657.143 583.919C655.833 583.399 654.503 582.939 652.353 582.149C653.203 584.119 653.623 585.419 654.283 586.579C660.523 597.649 666.833 608.679 673.053 619.769C674.823 622.929 676.453 626.179 677.943 629.489C678.673 631.119 679.103 632.939 679.373 634.719C679.713 637.019 679.083 639.049 676.813 640.239C674.703 641.349 672.823 640.579 671.323 639.189C669.603 637.599 668.063 635.779 666.623 633.919C654.353 618.039 644.183 600.849 635.783 582.689C632.843 576.349 629.243 572.049 622.383 569.949C615.293 567.779 608.483 564.649 601.663 561.689C598.163 560.169 595.093 560.639 592.753 563.309C590.023 566.409 587.473 569.769 585.453 573.359C583.313 577.169 583.663 577.679 586.823 580.879C603.933 598.189 621.083 615.459 638.183 632.779C655.023 649.839 671.843 666.939 688.623 684.059C690.713 686.189 692.883 687.629 695.963 688.249C710.723 691.229 725.403 694.579 740.143 697.649C747.723 699.229 750.183 701.849 750.663 709.789C751.333 721.029 751.933 732.269 752.583 743.499C752.633 744.389 752.863 745.259 753.073 746.549C755.603 746.819 758.083 747.249 760.583 747.329C787.823 748.169 815.063 748.199 842.273 746.269C845.713 746.029 849.163 745.879 852.613 745.899C854.773 745.909 856.973 746.169 859.093 746.609C862.293 747.279 864.203 749.169 864.173 751.449C864.133 754.259 862.203 755.619 859.843 756.399C858.133 756.969 856.343 757.38 854.563 757.669C837.493 760.45 820.283 761.519 803.023 761.739C793.033 761.869 783.043 761.689 773.053 761.649C771.323 761.649 769.593 761.649 766.713 761.649C768.693 763.829 769.803 765.159 771.023 766.389C779.623 774.999 788.293 783.539 796.813 792.229C799.213 794.679 801.453 796.109 805.263 795.749C809.343 795.369 813.543 796.549 817.713 796.769C831.853 797.539 845.993 798.169 860.133 798.919C863.023 799.07 865.933 799.299 868.773 799.829C872.773 800.579 874.593 802.169 874.703 804.469C874.823 806.939 872.873 808.579 868.463 809.349C866.153 809.749 863.763 810.009 861.423 809.909C849.093 809.399 836.763 808.769 824.433 808.139C820.893 807.959 817.363 807.669 812.673 807.359C814.003 808.989 814.473 809.679 815.063 810.269C822.753 817.989 830.483 825.669 838.163 833.409C840.033 835.299 842.103 836.259 844.843 836.469C855.343 837.279 865.823 838.299 876.293 839.329C878.253 839.519 880.373 839.819 882.043 840.739C883.253 841.409 884.533 843.199 884.523 844.489C884.523 845.769 883.183 847.369 881.993 848.219C880.913 848.989 879.263 849.169 877.853 849.239C871.873 849.529 865.883 849.689 859.903 849.879C858.543 849.919 857.183 849.879 854.523 849.879C861.363 856.819 867.293 862.829 873.563 869.189C874.803 868.839 876.313 868.359 877.853 867.979C887.213 865.699 897.083 871.359 899.723 880.519C902.273 889.329 896.813 899.259 887.563 901.899C881.273 903.699 875.193 902.559 870.233 898.149C865.213 893.689 863.623 887.889 865.103 881.319C865.503 879.569 866.103 877.879 866.633 876.079C859.533 869.049 852.503 862.089 844.603 854.269C844.333 860.339 844.103 865.139 843.903 869.939C843.763 873.389 843.833 876.849 843.483 880.279C843.263 882.399 842.813 884.669 841.813 886.499C839.723 890.309 835.113 890.419 833.103 886.589C831.903 884.299 831.403 881.389 831.393 878.759C831.333 868.409 831.363 858.049 831.823 847.709C832.023 843.309 830.733 840.239 827.553 837.239C820.033 830.129 812.863 822.649 805.533 815.339C804.273 814.079 802.933 812.899 800.943 811.039C800.233 816.079 799.623 820.309 799.053 824.539C796.973 840.039 793.863 855.319 789.573 870.359C789.123 871.929 788.623 873.499 787.923 874.959C786.393 878.159 784.103 879.539 781.593 878.999C779.003 878.439 777.433 876.309 777.583 872.699C777.753 868.529 778.063 864.339 778.763 860.239C782.193 840.039 785.763 819.869 789.313 799.539C777.803 788.199 766.043 776.619 753.873 764.629C753.313 766.109 752.453 767.809 752.023 769.609C748.703 783.559 745.203 797.459 742.293 811.499C739.753 823.759 738.113 836.199 735.673 848.479C734.873 852.489 733.003 856.339 731.253 860.089C730.233 862.269 728.273 863.949 725.563 863.459C722.833 862.969 721.653 860.689 721.423 858.299C721.013 853.999 720.393 849.549 721.023 845.339C725.173 817.319 730.043 789.419 737.993 762.159C738.443 760.62 738.713 759.019 739.203 756.849C732.983 756.369 727.103 756.009 721.243 755.449C714.563 754.809 707.873 754.149 701.223 753.199C694.463 752.229 692.933 750.589 691.693 744.029C688.573 727.439 685.403 710.869 682.473 694.249C682.003 691.609 680.503 690.079 678.843 688.449C663.053 672.899 647.233 657.389 631.463 641.819C613.753 624.339 596.093 606.809 578.393 589.309C577.123 588.049 575.793 586.859 573.963 585.139C570.153 587.649 566.473 590.079 562.573 592.659C564.763 597.779 566.693 602.259 568.603 606.739C571.953 614.589 575.453 622.379 578.593 630.299C580.013 633.869 582.153 636.459 585.413 638.409C600.363 647.359 615.263 656.379 630.173 665.389C632.033 666.509 634.033 667.49 635.653 668.899C638.763 671.609 639.343 675.489 637.483 678.759C635.653 681.979 631.933 683.479 628.053 682.269C626.353 681.739 624.783 680.729 623.223 679.829C613.793 674.379 604.383 668.889 594.953 663.439C594.523 663.189 593.983 663.109 592.923 662.769C593.443 664.469 593.723 665.809 594.253 667.059C598.993 678.259 603.853 689.409 608.473 700.659C609.683 703.599 611.523 705.279 614.423 706.439C626.713 711.369 638.923 716.469 651.153 721.549C652.473 722.099 653.833 722.74 654.923 723.649C657.343 725.659 657.993 728.879 656.783 731.539C655.603 734.139 652.623 735.869 649.603 735.359C647.843 735.059 646.123 734.349 644.473 733.629C637.503 730.549 630.573 727.369 623.613 724.269C622.033 723.559 620.373 723.019 617.693 722.009C620.513 728.699 622.843 734.339 625.273 739.939C627.433 744.919 628.713 750.769 632.203 754.559C635.553 758.199 641.203 759.769 645.923 762.079C650.653 764.389 655.523 766.409 660.233 768.729C662.153 769.669 664.063 770.859 665.563 772.359C667.593 774.389 667.853 777.739 666.553 779.949C665.113 782.399 662.713 783.559 660.093 783.119C657.663 782.709 655.283 781.599 653.063 780.439C648.943 778.299 644.963 775.899 640.923 773.599C640.623 773.869 640.313 774.149 640.013 774.419C646.853 790.68 653.683 806.949 660.673 823.579C668.503 823.479 675.733 825.799 681.423 831.879C685.543 836.289 687.893 841.469 688.323 847.509C689.163 859.389 681.203 870.419 669.473 873.599C657.723 876.789 645.783 871.249 639.853 859.849C633.953 848.509 637.143 836.859 649.063 827.049C642.093 810.949 635.083 794.749 627.513 777.249C626.053 781.149 625.173 783.799 624.073 786.349C622.353 790.339 620.593 794.329 618.613 798.199C617.813 799.769 616.483 801.139 615.183 802.369C613.583 803.879 611.343 804.299 609.683 802.969C608.443 801.979 607.403 800.029 607.333 798.469C607.243 796.379 607.993 794.18 608.723 792.149C612.103 782.759 615.653 773.429 619.013 764.029C619.583 762.429 620.153 760.309 619.573 758.899C614.793 747.339 609.733 735.899 604.453 723.729C603.413 725.509 602.653 726.629 602.073 727.839C598.183 736.039 594.423 744.299 590.443 752.459C588.943 755.539 587.113 758.499 585.143 761.309C584.263 762.569 582.793 763.649 581.353 764.229C578.783 765.259 576.493 763.68 576.483 760.909C576.483 759.319 576.903 757.659 577.473 756.159C583.143 741.039 588.763 725.899 594.693 710.879C596.133 707.229 596.293 704.229 594.663 700.579C588.713 687.329 583.103 673.929 577.343 660.599C576.703 659.129 575.943 657.709 574.903 655.599C574.183 657.529 573.603 658.769 573.243 660.069C569.633 672.999 566.153 685.979 562.413 698.879C561.263 702.859 559.573 706.709 557.883 710.509C556.973 712.549 555.343 714.059 552.843 714.129C550.033 714.199 547.953 712.269 548.123 708.709C548.373 703.469 548.983 698.219 549.873 693.039C552.893 675.459 557.533 658.289 563.753 641.589C565.503 636.889 565.823 632.859 563.473 628.169C559.823 620.88 556.733 613.279 553.793 605.669C552.233 601.62 549.403 599.649 545.533 599.979C541.083 600.359 536.693 601.609 532.323 602.659C530.353 603.139 529.353 604.619 529.573 606.759C529.633 607.299 529.573 607.849 529.573 608.389C529.243 656.339 528.933 704.289 528.523 752.239C528.493 756.009 529.243 759.209 531.373 762.419C539.413 774.51 547.113 786.829 555.133 798.939C559.703 805.839 559.013 810.239 554.153 815.449C545.993 824.199 538.323 833.409 530.013 842.909C531.103 844.349 532.233 846.149 533.663 847.679C551.933 867.159 570.653 886.199 590.843 903.719C594.683 907.049 598.343 910.599 601.913 914.209C603.413 915.729 604.703 917.579 605.663 919.499C606.583 921.339 606.543 923.419 604.913 925.059C603.293 926.679 601.283 926.879 599.393 925.829C596.543 924.249 593.583 922.719 591.123 920.629C579.083 910.419 566.993 900.239 555.313 889.619C547.533 882.539 540.403 874.739 532.973 867.269C531.873 866.159 530.693 865.13 528.873 863.419C528.743 865.459 528.593 866.629 528.593 867.809C528.583 881.069 528.633 894.329 528.553 907.589C528.533 910.289 528.823 912.459 531.533 913.939C532.873 914.669 533.773 916.269 534.783 917.549C543.663 928.829 552.823 939.859 563.153 949.879C566.273 952.909 569.113 956.229 571.983 959.519C573.173 960.879 574.203 962.409 575.073 963.989C576.163 965.979 576.703 968.169 574.853 970.029C572.963 971.929 570.713 971.409 568.883 970.059C565.823 967.809 562.663 965.559 560.113 962.789C551.133 953.039 542.403 943.069 533.583 933.179C532.313 931.749 531.073 930.289 528.993 927.879C528.823 930.559 528.673 931.909 528.663 933.269C528.643 943.259 528.733 953.249 528.613 963.239C528.573 966.679 529.383 969.449 531.723 972.129C538.423 979.779 544.863 987.649 551.333 995.489C552.593 997.009 553.903 998.689 554.473 1000.52C554.883 1001.86 554.643 1004.18 553.753 1004.94C552.633 1005.9 550.443 1006.17 548.883 1005.88C547.413 1005.61 546.003 1004.38 544.823 1003.29C540.683 999.479 536.653 995.549 532.583 991.669C531.593 990.719 530.573 989.799 528.863 988.219V1015.33C533.663 1017.41 537.893 1020.64 539.853 1026.16C541.303 1030.23 541.503 1034.37 540.243 1038.47C537.993 1045.79 530.493 1050.57 522.433 1050.06C513.653 1049.5 508.053 1043.46 505.973 1035.71C504.233 1029.21 506.623 1019.92 518.423 1015.19V984.219C516.883 985.439 515.913 986.099 515.063 986.889C510.153 991.479 505.333 996.169 500.343 1000.66C498.613 1002.22 496.633 1003.81 494.483 1004.47C492.853 1004.98 490.473 1004.55 488.963 1003.64C486.893 1002.4 486.593 999.819 487.693 997.779C489.053 995.269 490.743 992.809 492.763 990.789C499.703 983.859 506.673 976.95 513.983 970.419C517.453 967.329 518.673 964.049 518.543 959.509C518.253 949.159 518.473 938.809 518.483 928.449C518.483 926.869 518.483 925.289 518.483 922.429C516.063 924.149 514.483 925.159 513.023 926.319C499.183 937.269 484.613 947.139 469.243 955.809C467.353 956.879 465.393 957.879 463.353 958.609C460.353 959.679 457.943 958.959 456.513 956.919C455.083 954.88 455.343 952.449 457.643 950.049C459.523 948.089 461.573 946.25 463.773 944.659C474.953 936.579 486.183 928.559 497.453 920.579C504.253 915.759 511.143 911.069 518.383 906.049V856.219C516.543 856.969 514.883 857.429 513.463 858.269C505.173 863.149 496.733 867.819 488.733 873.139C475.273 882.079 462.163 891.539 448.773 900.589C445.053 903.109 440.903 904.999 436.933 907.139C436.303 907.479 435.583 907.739 434.873 907.829C432.353 908.149 429.573 908.799 427.853 906.299C426.183 903.879 427.073 901.179 428.763 899.239C431.843 895.709 434.953 892.039 438.683 889.279C461.013 872.729 483.743 856.759 508.213 843.439C509.633 842.669 510.943 841.709 512.683 840.609C511.753 839.329 511.013 838.159 510.123 837.119C505.053 831.179 499.883 825.319 494.863 819.339C492.533 816.559 490.343 813.649 488.273 810.669C484.633 805.409 484.703 802.999 488.273 797.839C495.703 787.079 503.133 776.319 510.553 765.559C512.813 762.269 515.273 759.089 517.203 755.609C518.183 753.839 518.553 751.519 518.553 749.459C518.533 734.569 518.313 719.669 518.223 704.779C518.013 672.629 517.843 640.479 517.663 608.329C517.633 602.429 517.253 601.879 511.623 600.769C509.323 600.309 506.973 600.089 504.373 599.729C503.673 601.099 502.933 602.309 502.403 603.609C497.713 615.219 493.123 626.879 488.363 638.459C487.203 641.289 487.073 643.979 487.613 646.939C490.813 664.659 495.583 681.979 500.513 699.259C501.103 701.339 501.723 703.489 501.783 705.629C501.883 709.609 499.253 712.729 495.593 713.539C492.243 714.279 488.743 712.629 487.013 709.219C486.203 707.629 485.743 705.829 485.283 704.079C482.483 693.559 479.733 683.019 476.943 672.489C476.813 671.989 476.443 671.559 475.923 670.629C475.213 671.899 474.543 672.829 474.123 673.869C469.413 685.479 464.803 697.119 460.023 708.699C458.983 711.219 458.883 713.399 459.983 715.959C465.253 728.309 470.353 740.719 475.493 753.119C475.973 754.279 476.463 755.489 476.653 756.719C477.183 760.159 475.563 763.049 472.613 764.229C469.863 765.329 466.773 764.579 464.813 762.009C463.733 760.589 462.963 758.889 462.313 757.209C459.623 750.269 457.043 743.289 454.393 736.339C453.693 734.489 452.893 732.68 451.853 730.169C450.913 732.06 450.233 733.259 449.713 734.529C446.333 742.759 443.073 751.029 439.603 759.219C438.553 761.709 438.403 763.879 439.373 766.489C442.703 775.509 445.793 784.619 448.893 793.719C449.473 795.409 449.913 797.239 449.933 799.009C449.963 801.969 448.043 804.589 445.583 805.319C442.673 806.189 439.943 805.489 438.313 803.019C436.853 800.809 435.903 798.189 435.103 795.629C433.753 791.319 432.703 786.929 430.483 782.429C423.793 798.809 417.103 815.199 410.193 832.119C415.793 837.499 419.323 844.419 418.953 852.929C418.703 858.739 416.873 863.949 413.013 868.379C405.313 877.219 392.603 879.719 382.293 874.429C371.113 868.689 366.233 857.309 369.443 844.489C372.623 831.789 381.963 826.039 399.643 826.109C406.053 809.929 412.513 793.639 419.383 776.299C416.823 777.299 415.243 777.889 413.673 778.519C408.963 780.419 404.333 782.519 399.533 784.149C397.373 784.889 394.853 785.109 392.583 784.849C388.473 784.389 386.923 780.249 389.743 777.219C391.303 775.549 393.443 774.269 395.543 773.279C404.563 768.999 413.693 764.959 422.693 760.659C424.363 759.859 426.363 758.569 427.013 757.009C431.753 745.629 436.183 734.129 441.023 721.879C439.023 722.359 437.703 722.559 436.473 722.999C427.933 726.059 419.453 729.309 410.853 732.189C407.113 733.439 403.143 734.099 399.233 734.739C396.943 735.109 394.723 734.319 393.973 731.859C393.203 729.289 394.943 727.759 397.003 726.739C403.333 723.579 409.623 720.32 416.073 717.419C425.673 713.109 435.383 709.039 445.093 704.969C447.223 704.079 448.673 702.93 449.563 700.659C455.443 685.609 461.473 670.619 467.433 655.609C467.683 654.979 467.723 654.269 468.003 652.899C466.253 653.699 464.983 654.169 463.823 654.819C452.753 661.059 441.743 667.399 430.623 673.559C426.833 675.659 422.823 677.409 418.843 679.139C417.553 679.699 416.013 679.99 414.613 679.919C410.553 679.709 408.523 675.859 410.873 672.539C412.313 670.519 414.343 668.839 416.333 667.289C432.473 654.769 449.993 644.449 468.493 635.889C474.503 633.109 478.503 629.659 480.503 623.179C482.683 616.089 485.723 609.239 488.713 602.429C490.443 598.489 489.693 595.339 486.843 592.539C482.933 588.679 478.543 585.529 472.823 584.439C471.873 585.269 470.883 586.049 469.993 586.929C435.723 620.729 401.493 654.569 367.163 688.309C364.453 690.979 362.753 693.819 361.993 697.529C359.093 711.749 355.923 725.919 353.013 740.139C351.373 748.159 348.673 750.549 340.643 751.029C328.693 751.739 316.763 752.649 303.993 753.529C303.743 755.899 303.283 758.509 303.223 761.119C302.593 788.179 302.353 815.239 304.253 842.269C304.533 846.249 304.523 850.259 304.563 854.249C304.573 855.699 304.413 857.159 304.173 858.589C303.563 862.279 301.973 864.209 299.463 864.459C296.863 864.719 294.843 863.319 294.023 859.469C292.733 853.449 291.813 847.339 291.073 841.219C288.383 818.979 288.783 796.619 288.943 774.279C288.953 772.299 288.943 770.319 288.943 767.569C287.493 768.609 286.453 769.159 285.653 769.949C276.133 779.429 266.683 788.999 257.103 798.429C255.243 800.259 254.833 802.029 254.893 804.629C254.993 809.129 254.103 813.649 253.843 818.179C253.123 830.859 252.533 843.549 251.843 856.229C251.623 860.209 251.273 864.19 250.943 868.159C250.863 869.06 250.713 869.979 250.423 870.829C249.693 872.969 248.613 874.999 246.043 875.059C243.413 875.119 242.203 873.18 241.743 870.909C241.243 868.43 240.703 865.879 240.793 863.389C241.273 849.969 241.923 836.549 242.553 823.139C242.693 820.139 243.003 817.139 243.323 812.959C241.563 814.429 240.733 815.019 240.023 815.729C232.523 823.209 225.073 830.74 217.523 838.169C215.333 840.32 214.163 842.659 213.943 845.789C213.243 855.749 212.323 865.699 211.413 875.639C211.233 877.619 210.833 879.599 210.313 881.519C209.743 883.619 208.353 885.039 206.033 885.019C203.683 884.999 202.243 883.49 201.873 881.399C201.273 878.009 200.873 874.569 200.743 871.129C200.563 866.249 200.693 861.359 200.693 856.469C200.293 856.239 199.903 856.009 199.503 855.789L199.483 855.829ZM186.393 660.809C186.253 669.449 193.443 676.799 202.133 676.919C211.283 677.049 218.313 670.509 218.553 661.639C218.793 653.009 211.333 645.529 202.303 645.339C192.963 645.149 186.543 651.389 186.393 660.809ZM389.583 186.769C381.163 186.639 373.733 194.119 373.693 202.769C373.653 211.979 380.233 218.949 389.093 219.069C397.643 219.189 405.143 211.559 405.283 202.599C405.423 193.419 398.973 186.919 389.583 186.769ZM657.023 217.169C666.103 217.069 673.743 209.739 673.653 201.209C673.563 192.799 665.983 185.569 657.293 185.619C648.543 185.659 640.853 193.439 641.073 202.019C641.303 210.619 648.293 217.269 657.013 217.169H657.023ZM848.023 405.639C857.403 405.709 863.593 399.499 863.683 389.949C863.763 381.429 856.343 374.049 847.693 374.049C838.573 374.049 831.613 380.759 831.553 389.619C831.493 398.359 838.903 405.569 848.023 405.639ZM644.943 848.919C645.043 858.19 651.633 864.459 661.033 864.229C669.243 864.019 676.453 856.599 676.523 848.279C676.593 839.059 669.403 831.719 660.503 831.929C651.863 832.129 644.843 839.799 644.953 848.929L644.943 848.919ZM185.253 393.309C185.323 401.989 192.533 409.319 201.093 409.399C209.873 409.489 217.003 402.259 216.823 393.449C216.643 384.439 209.183 376.799 200.693 376.909C192.193 377.029 185.183 384.469 185.253 393.309ZM393.543 833.799C384.553 833.709 376.593 840.859 376.293 849.299C376.003 857.389 383.723 865.149 392.273 865.359C401.193 865.579 408.803 858.299 408.873 849.479C408.943 840.739 402.243 833.889 393.543 833.799ZM833.363 657.099C833.303 666.119 840.503 673.979 848.953 674.129C857.333 674.269 864.713 666.869 864.883 658.149C865.053 649.24 857.743 641.69 848.923 641.669C840.193 641.649 833.423 648.369 833.373 657.109L833.363 657.099ZM348.173 309.399C337.523 308.339 327.073 307.049 316.563 306.529C316.403 306.899 316.243 307.259 316.083 307.629C328.463 319.949 340.833 332.269 353.213 344.579C353.493 344.379 353.763 344.169 354.043 343.969C352.113 332.569 350.173 321.179 348.173 309.389V309.399ZM518.123 828.599C519.293 819.619 518.933 778.719 517.703 774.649C510.853 784.289 504.173 793.699 497.253 803.439C504.083 811.679 510.763 819.729 518.123 828.609V828.599ZM701.913 741.709C712.763 742.709 723.143 743.659 733.993 744.649C730.723 739.499 700.143 709.219 696.083 707.079C698.023 718.619 699.913 729.839 701.913 741.709ZM305.983 733.609C318.653 721.099 330.973 708.949 343.583 696.499C332.003 698.459 320.563 700.389 308.843 702.379C307.863 713.079 306.913 723.429 305.983 733.609ZM828.283 532.299C815.013 531.139 778.173 531.639 774.373 532.979C783.933 539.759 793.353 546.439 803.003 553.289C811.283 546.409 819.323 539.739 828.283 532.299ZM705.943 354.589C718.183 352.509 729.553 350.579 741.253 348.589C742.243 337.829 743.213 327.379 744.183 316.909C731.473 329.439 719.143 341.579 705.953 354.589H705.943ZM275.413 518.809C275.473 518.499 275.523 518.199 275.583 517.889C266.153 511.209 256.723 504.519 247.423 497.929C238.543 503.789 225.033 515.589 223.453 518.809H275.423H275.413ZM531.633 275.509C531.983 275.649 532.333 275.789 532.683 275.939C539.353 266.559 546.023 257.179 552.613 247.909C547.143 239.489 535.083 225.619 531.633 223.829V275.509ZM502.763 460.139C508.573 474.069 514.223 487.609 519.873 501.159C521.463 491.139 520.833 459.779 519.753 456.479C514.303 457.649 508.883 458.819 502.753 460.139H502.763ZM570.533 473.099C565.373 469.859 560.543 466.829 555.453 463.639C549.773 477.449 544.173 491.039 539.003 503.599C549.103 493.839 559.753 483.529 570.533 473.109V473.099ZM500.283 530.899C500.233 530.639 500.173 530.389 500.123 530.129H455.893C457.203 536.119 458.413 541.689 459.733 547.729C473.273 542.109 486.783 536.499 500.283 530.899ZM511.293 546.979C510.963 546.719 510.633 546.469 510.303 546.209C499.953 556.699 489.603 567.189 479.313 577.619C484.653 581.029 489.483 584.119 494.603 587.389C500.163 573.909 505.723 560.439 511.283 546.979H511.293ZM463.173 495.039C476.803 500.669 490.533 506.349 503.103 511.549C493.413 501.489 483.043 490.739 472.713 480.019C469.603 484.909 466.533 489.739 463.173 495.039ZM594.303 520.929C592.883 514.719 591.613 509.169 590.253 503.269C576.493 508.989 563.043 514.589 549.593 520.179C549.653 520.429 549.713 520.679 549.773 520.929H594.303ZM546.633 539.309C546.403 539.659 546.163 540.009 545.933 540.359C556.343 550.639 566.763 560.929 577.193 571.229C580.613 565.849 583.683 561.039 586.953 555.899C573.533 550.379 560.083 544.839 546.633 539.299V539.309ZM547.293 590.819C545.403 586.269 543.553 581.809 541.703 577.349C539.763 572.669 537.913 567.949 535.863 563.319C533.983 559.079 532.753 554.499 529.673 549.739V594.669C535.633 593.37 541.193 592.149 547.293 590.819ZM505.073 242.409C510.113 249.949 514.823 257.019 519.563 264.069C519.843 264.489 520.323 264.789 520.743 265.169C521.893 261.209 522.143 229.459 520.923 222.839C515.363 229.709 510.193 236.089 505.083 242.409H505.073ZM223.433 529.079C223.293 529.459 223.153 529.839 223.013 530.219C229.443 535.359 235.873 540.499 242.303 545.639C245.353 543.389 247.793 541.529 250.303 539.769C252.823 537.999 255.473 536.429 257.953 534.599C260.243 532.909 263.353 532.139 264.983 529.079H223.433ZM308.923 316.289C308.043 318.769 309.123 331.589 311.493 339.679C320.263 341.339 329.093 343.009 337.373 344.579C327.863 335.129 318.183 325.499 308.923 316.299V316.289ZM808.023 505.429C800.003 510.929 792.653 515.979 784.953 521.259C791.473 522.599 823.493 522.419 827.303 520.989C820.823 515.759 814.513 510.669 808.023 505.429ZM705.933 337.979C715.673 328.159 725.403 318.349 735.043 308.629C727.393 309.459 719.193 310.349 711.013 311.229C709.223 320.659 707.543 329.509 705.933 337.979ZM529.183 785.189C528.003 793.019 528.263 823.609 529.573 827.739C534.923 821.069 540.073 814.639 545.063 808.419C539.633 800.479 534.643 793.169 529.173 785.189H529.183ZM344.323 712.139C339.103 715.539 316.243 738.679 314.473 742.449C322.913 741.499 331.123 740.579 339.103 739.689C340.933 730.049 342.603 721.219 344.323 712.139ZM741.783 735.619C740.853 727.519 741.013 719.169 738.723 711.299C729.603 709.609 720.913 707.989 712.223 706.379C722.263 716.319 732.003 725.939 741.783 735.619ZM527.733 10.1494C523.413 10.2894 519.153 14.8094 519.193 19.1994C519.233 23.3894 523.483 27.3494 527.873 27.2794C532.483 27.2094 536.193 23.1193 536.083 18.2393C535.983 13.4693 532.403 10.0094 527.723 10.1594L527.733 10.1494ZM165.093 873.469C161.023 873.419 156.173 877.619 155.973 881.359C155.733 885.929 159.823 890.219 164.423 890.229C169.593 890.229 173.303 886.759 173.273 881.949C173.243 877.369 169.533 873.529 165.083 873.469H165.093ZM26.8128 522.699C26.7528 518.029 22.8328 514.459 17.8128 514.529C12.9128 514.589 9.69273 517.899 9.79273 522.769C9.89273 527.259 14.0826 531.229 18.7026 531.209C23.0826 531.189 26.8628 527.219 26.8128 522.699ZM522.313 1040.83C526.683 1040.73 530.823 1036.35 530.813 1031.86C530.803 1027.56 526.733 1023.67 522.283 1023.71C517.633 1023.75 514.073 1027.68 514.123 1032.72C514.173 1037.46 517.683 1040.95 522.313 1040.84V1040.83ZM873.063 885.379C872.973 889.559 876.993 894.319 880.823 894.559C885.463 894.849 889.573 890.949 889.633 886.199C889.693 880.849 886.493 877.329 881.563 877.339C876.863 877.339 873.163 880.849 873.063 885.379ZM885.223 177.519C889.463 177.439 893.943 173.299 894.013 169.409C894.093 164.629 890.163 160.689 885.443 160.809C880.253 160.939 876.693 164.459 876.853 169.289C877.013 173.899 880.783 177.609 885.223 177.529V177.519ZM1031.93 536.439C1036.84 536.529 1040.28 533.309 1040.35 528.559C1040.42 524.149 1036.3 519.949 1031.72 519.789C1027.31 519.629 1023.49 523.359 1023.35 527.949C1023.21 532.699 1026.89 536.349 1031.94 536.439H1031.93ZM176.933 165.559C176.983 161.299 173.013 156.609 169.193 156.439C164.553 156.229 160.363 160.219 160.343 164.849C160.313 170.029 163.713 173.659 168.563 173.649C173.323 173.629 176.873 170.199 176.933 165.559ZM548.423 560.289C552.173 568.839 555.503 576.429 559.003 584.399C561.953 582.139 564.433 580.239 566.953 578.309C560.823 572.349 555.003 566.689 548.413 560.289H548.423ZM471.753 566.869C477.603 560.979 483.333 555.209 489.093 549.409C481.613 552.669 473.993 555.999 466.113 559.439C468.413 562.469 470.243 564.879 471.743 566.869H471.753ZM517.663 592.559C517.633 584.129 517.783 576.179 517.273 568.229C513.293 574.529 508.543 587.419 508.383 591.349C511.223 591.719 514.083 592.089 517.663 592.559ZM578.463 484.269C572.753 490.099 567.083 495.879 561.873 501.199C568.633 498.249 576.193 494.949 583.993 491.549C581.823 488.689 579.983 486.269 578.463 484.269ZM501.593 490.559C497.823 481.949 494.523 474.429 491.093 466.599C488.133 468.839 485.633 470.729 483.343 472.459C489.333 478.399 495.083 484.099 501.593 490.559ZM567.933 533.259C567.863 533.549 567.793 533.839 567.723 534.139C575.193 537.079 582.673 540.019 590.703 543.179C591.173 539.579 591.573 536.499 591.993 533.269H567.933V533.259ZM532.673 482.699C532.993 482.799 533.323 482.889 533.643 482.989C536.613 475.389 539.583 467.779 542.743 459.679C538.923 459.259 535.963 458.929 532.673 458.569V482.699ZM482.323 517.709C482.343 517.419 482.363 517.129 482.393 516.829C474.843 513.879 467.303 510.939 459.383 507.849C458.893 511.369 458.473 514.359 458.003 517.709H482.323Z" fill="white"/>
</svg>

`,
  kr = ({ type: n = "rain", intensity: e = 0.5 }) => {
    const r = {
        fpsLimit: 60,
        fullScreen: { enable: !0, zIndex: -1 },
        particles: {
          number: {
            value: 200,
            density: { enable: !0, width: 800, height: 800 },
          },
          color: { value: ["#9ccff8", "#719fc4"] },
          shape: {
            type: "image",
            options: {
              image: {
                src: `data:image/svg+xml;base64,${btoa(hw)}`,
                width: 76,
                height: 119,
              },
            },
          },
          opacity: { value: 0.8, animation: { enable: !0 } },
          move: {
            enable: !0,
            speed: 10,
            direction: "bottom",
            random: !0,
            straight: !1,
            outModes: "out",
            angle: { offset: { min: 1, max: 5 }, value: { min: 1, max: 5 } },
            drift: 0,
          },
          size: {
            value: { min: 2, max: 8 },
            animation: { enable: !0, speed: 0.5, sync: !1 },
          },
        },
        background: { color: "#000000", opacity: 0 },
        detectRetina: !0,
      },
      o = {
        fpsLimit: 60,
        fullScreen: { enable: !0, zIndex: -1 },
        particles: {
          number: {
            value: 400 * e,
            density: { enable: !0, width: 800, height: 800 },
          },
          color: {
            value: ["#ffffffa1", "#d1d1d1b9"],
            animation: { enable: !0, speed: 1, sync: !0 },
          },
          shape: {
            type: "image",
            options: {
              image: {
                src: `data:image/svg+xml;base64,${btoa(pw)}`,
                width: 119,
                height: 119,
              },
            },
          },
          opacity: {
            value: 0.7,
            animation: {
              enable: !0,
              speed: 1,
              count: 0,
              sync: !1,
              decay: 0,
              mode: "auto",
              delay: 0,
            },
          },
          move: {
            enable: !0,
            speed: 5,
            direction: "bottom",
            random: !0,
            straight: !1,
            outModes: "out",
            angle: { offset: { min: 1, max: 5 }, value: { min: 1, max: 10 } },
            drift: 0,
          },
          size: {
            value: { min: 5, max: 15 },
            animation: { enable: !0, speed: 0.5, sync: !1 },
          },
        },
        detectRetina: !0,
      },
      l = {
        fpsLimit: 60,
        fullScreen: { enable: !0, zIndex: -1 },
        particles: {
          number: {
            value: 70,
            density: { enable: !0, width: 700, height: 600 },
          },
          color: {
            value: ["#f0f0f080", "#e0e0e080"],
            animation: { enable: !0, speed: 0.5, sync: !0 },
          },
          shape: {
            type: "image",
            options: {
              image: [
                { src: sw, width: 60, height: 20 },
                { src: lw, width: 60, height: 20 },
                { src: aw, width: 60, height: 20 },
                { src: uw, width: 60, height: 20 },
              ],
            },
          },
          opacity: {
            value: 0.9,
            animation: {
              enable: !0,
              speed: 0.5,
              count: 0,
              sync: !1,
              decay: 0,
              mode: "auto",
              delay: 0,
            },
          },
          move: {
            enable: !0,
            speed: 1.5,
            direction: "none",
            random: !0,
            straight: !1,
            outModes: "out",
            drift: 0,
          },
          size: {
            value: { min: 15, max: 25 },
            animation: { enable: !0, speed: 0.5, sync: !1 },
          },
        },
        detectRetina: !0,
      },
      u = {
        fpsLimit: 60,
        fullScreen: { enable: !0, zIndex: -1 },
        particles: {
          number: {
            value: 50,
            density: { enable: !0, width: 800, height: 600 },
          },
          color: {
            value: ["#f0f0f080", "#e0e0e080"],
            animation: { enable: !0, speed: 0.5, sync: !0 },
          },
          shape: {
            type: "image",
            options: { image: [{ src: fw, width: 40, height: 35 }] },
          },
          opacity: {
            value: 0.9,
            animation: {
              enable: !0,
              speed: 0.5,
              count: 0,
              sync: !1,
              decay: 0,
              mode: "auto",
              delay: 0,
            },
          },
          move: {
            enable: !0,
            speed: 1.5,
            direction: "none",
            random: !0,
            straight: !1,
            outModes: "out",
            drift: 0,
          },
          size: {
            value: { min: 15, max: 20 },
            animation: { enable: !0, speed: 0.5, sync: !1 },
          },
        },
        detectRetina: !0,
      },
      c = {
        fpsLimit: 60,
        fullScreen: { enable: !0, zIndex: -1 },
        particles: {
          number: {
            value: 60,
            density: { enable: !0, width: 700, height: 600 },
          },
          color: {
            value: ["#f0f0f080", "#e0e0e080"],
            animation: { enable: !0, speed: 0.5, sync: !0 },
          },
          shape: {
            type: "image",
            options: { image: [{ src: dw, width: 60, height: 40 }] },
          },
          opacity: {
            value: 0.9,
            animation: {
              enable: !0,
              speed: 0.5,
              count: 0,
              sync: !1,
              decay: 0,
              mode: "auto",
              delay: 0,
            },
          },
          move: {
            enable: !0,
            speed: 1.5,
            direction: "none",
            random: !0,
            straight: !1,
            outModes: "out",
            drift: 0,
          },
          size: {
            value: { min: 15, max: 20 },
            animation: { enable: !0, speed: 0.5, sync: !1 },
          },
        },
        detectRetina: !0,
      },
      d = {
        fpsLimit: 60,
        fullScreen: { enable: !0, zIndex: -1 },
        particles: {
          number: {
            value: 30,
            density: { enable: !0, width: 600, height: 500 },
          },
          color: {
            value: ["#f0f0f080", "#e0e0e080"],
            animation: { enable: !0, speed: 0.5, sync: !0 },
          },
          shape: {
            type: "image",
            options: { image: [{ src: cw, width: 40, height: 40 }] },
          },
          opacity: {
            value: 1,
            animation: {
              enable: !0,
              speed: 0.5,
              count: 0,
              sync: !1,
              decay: 0,
              mode: "auto",
              delay: 0,
            },
          },
          move: {
            enable: !0,
            speed: 3,
            direction: "none",
            random: !0,
            straight: !1,
            outModes: "out",
            drift: 0,
          },
          size: {
            value: { min: 15, max: 20 },
            animation: { enable: !0, speed: 0.5, sync: !1 },
          },
        },
        detectRetina: !0,
      };
    async function p(m, g = !0) {
      (await mw(),
        await yw(),
        await m.addPreset("rain", r, !1),
        await m.addPreset("snow", o, !1),
        await m.refresh(g));
    }
    return (
      ve.useEffect(() => {
        (async () => {
          const g = _3;
          (await rw(g), await p(g));
        })().catch(console.error);
      }, []),
      J.jsx(ow, {
        id: "tsparticles-weather",
        options:
          n === "rain"
            ? r
            : n === "snow"
              ? o
              : n === "nublado"
                ? l
                : n === "lightning"
                  ? d
                  : n === "ensolarado"
                    ? u
                    : n === "fog"
                      ? c
                      : r,
        style: { position: "relative", width: "100%", height: "100%" },
      })
    );
  };
function mw(n, e) {
  throw new Error("Function not implemented.");
}
function yw(n, e) {
  throw new Error("Function not implemented.");
}
const gw = {
    CHUVOSO: n1,
    NUBLADO: i1,
    ENSOLARADO: r1,
    TEMPESTADE: o1,
    NEVE: s1,
    NEBLINA: l1,
    LIMPO: r1,
    NEUTRO: i1,
    POLUIDO: l1,
    ENCOBERTO: i1,
    LIMPANDO: n1,
    NEVANDO: s1,
    NEVASCA: s1,
    NEVE_LEVE: s1,
    HALLOWEEN: o1,
  },
  vw = () => {
    const [n, e] = ve.useState("ENSOLARADO"),
      { selected: r } = b6(cp);
    return (
      ve.useEffect(() => {
        r && r !== "" && e(r);
      }, [r]),
      J.jsx(vp, {
        name: n,
        children: J.jsxs("div", {
          className: "weather",
          children: [
            n === "NEVE"
              ? J.jsx(kr, { type: "snow" })
              : n === "CHUVOSO"
                ? J.jsx(kr, { type: "rain" })
                : n === "TEMPESTADE"
                  ? J.jsx(kr, { type: "lightning" })
                  : n === "NEBLINA"
                    ? J.jsx(kr, { type: "fog" })
                    : n === "ENSOLARADO"
                      ? J.jsx(kr, { type: "ensolarado" })
                      : J.jsx(kr, { type: "nublado" }),
            J.jsx("div", {
              className: "weather-name",
              children: J.jsx("span", { children: n }),
            }),
            J.jsx("div", { id: "sep" }),
            J.jsx("div", { className: "current", children: "Clima Atual" }),
            J.jsxs("div", {
              className: "hour",
              children: [
                window.gameTime || "12:00",
                J.jsx("span", { children: "PM" }),
              ],
            }),
            J.jsx("img", {
              src: gw[n],
              alt: `${n} weather icon`,
              style: { maxWidth: "2.375em" },
            }),
          ],
        }),
      })
    );
  },
  Cw = Qr.div`
  display: grid;
  grid-template-columns: repeat(2, 8.625em);
  margin-inline: auto;
  justify-content: center;
  gap: 0.3125em;
  max-height: 15.625em;
  overflow-y: auto;
  overflow-x: hidden;
  transition: all 0.3s ease-in-out;
  padding-right: 0.25em;

  &::-webkit-scrollbar {
    width: 0.25em;
  }
  &::-webkit-scrollbar-track {
    background: transparent;
  }
  &::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.2);
    border-radius: 0.25em;
  }

  .selected {
    border-radius: var(--radius-lg, 0.5em);
    background: linear-gradient(94deg, #225ece75 2.29%, #225ece75 96.96%);

    span {
      color: var(--color-white-90, rgba(255, 255, 255, 0.90));
    }
  }

`,
  ww = Qr.div`
  width: 100%;
  height: 5em;
  display: flex;
  padding: 0.25em 0.375em;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  gap: 0.3125em;
  flex: 1 0 0;
  border-radius: 0.5em;
  background: rgba(232, 121, 249, 0.05);
  transition: background 0.3s ease-in-out;


  

  span {
    color: rgba(255, 255, 255, 0.60);
    text-align: center;
    font-family: Arame;
    font-size: 0.75em;
    font-style: normal;
    font-weight: 400;
    line-height: 1em; /* 133.333% */
    letter-spacing: 0em;
    z-index: 10;
  }

  img {
    width: 3em;
    z-index: 10;
  }

  &:hover {
    border-radius: var(--radius-lg, 0.5em);
    border: none;
    background: linear-gradient(94deg, #225ece75 2.29%, #225ece75 96.96%);

    span {
      color: var(--color-white-90, rgba(255, 255, 255, 0.90));
    }
  }

`,
  Q1 = {
    ENSOLARADO: r1,
    NUBLADO: i1,
    NEBLINA: l1,
    CHUVOSO: n1,
    TEMPESTADE: o1,
    NEVE: s1,
    LIMPO: r1,
    NEUTRO: i1,
    POLUIDO: l1,
    ENCOBERTO: i1,
    LIMPANDO: n1,
    NEVANDO: s1,
    NEVASCA: s1,
    NEVE_LEVE: s1,
    HALLOWEEN: o1,
  },
  xw = () => {
    const [n, e] = ve.useState(null),
      r = w6(),
      o = (l) => {
        (e(l), r(up(l)), Ml("setWeather", l));
      };
    return J.jsx(Cw, {
      children: Object.keys(Q1).map((l) =>
        J.jsx(_w, { name: l, isSelected: n === l, onClick: () => o(l) }, l),
      ),
    });
  },
  _w = (n) =>
    J.jsxs(ww, {
      className: n.isSelected ? "selected" : "",
      onClick: n.onClick,
      children: [
        J.jsx("span", { children: n.name }),
        J.jsx("img", { src: Q1[n.name], alt: `${n.name} weather icon` }),
      ],
    });
var d0, h0;
function r3() {
  return (
    (r3 = Object.assign
      ? Object.assign.bind()
      : function (n) {
          for (var e = 1; e < arguments.length; e++) {
            var r = arguments[e];
            for (var o in r) ({}).hasOwnProperty.call(r, o) && (n[o] = r[o]);
          }
          return n;
        }),
    r3.apply(null, arguments)
  );
}
var bw = function (e) {
  return ve.createElement(
    "svg",
    r3(
      {
        xmlns: "http://www.w3.org/2000/svg",
        width: 16,
        height: 16,
        fill: "none",
      },
      e,
    ),
    d0 ||
      (d0 = ve.createElement(
        "g",
        {
          stroke: "#fff",
          strokeLinecap: "round",
          strokeLinejoin: "round",
          clipPath: "url(#arrow_svg__a)",
        },
        ve.createElement("path", {
          d: "M13.152 7.286a5.333 5.333 0 1 1-1.381-2.39l.472.471",
          opacity: 0.5,
        }),
        ve.createElement("path", { d: "M9.414 5.367h2.829V2.538" }),
      )),
    h0 ||
      (h0 = ve.createElement(
        "defs",
        null,
        ve.createElement(
          "clipPath",
          { id: "arrow_svg__a" },
          ve.createElement("path", { fill: "#fff", d: "M0 0h16v16H0z" }),
        ),
      )),
  );
};
const kw = () => {
  const [n, e] = ve.useState(t1());
  return (
    hp("setVisible", (r) => e(r)),
    ve.useEffect(() => {
      if (!n) return;
      const r = (o) => {
        ["Escape"].includes(o.code) && Ml("hideFrame");
      };
      return (
        window.addEventListener("keydown", r),
        () => window.removeEventListener("keydown", r)
      );
    }, [n]),
    n && n
      ? J.jsx("div", {
          className: "nui",
          children: J.jsxs(pp, {
            children: [
              J.jsx(yp, {}),
              J.jsx(vw, {}),
              J.jsx(xw, {}),
              J.jsxs("div", {
                className: "buttons",
                children: [
                  J.jsxs("div", {
                    className: "reset",
                    onClick: () => Ml("resetWeather"),
                    children: [
                      J.jsx(bw, {}),
                      J.jsx("span", { children: "Resetar Clima" }),
                    ],
                  }),
                  J.jsx("div", {
                    className: "reset",
                    onClick: () => Ml("removeClouds"),
                    children: J.jsx("span", { children: "Remover nuvem" }),
                  }),
                ],
              }),
            ],
          }),
        })
      : null
  );
};
e2.createRoot(document.getElementById("root")).render(
  J.jsxs(bn.StrictMode, {
    children: [
      J.jsx(n6, {}),
      J.jsx(g6, { store: fp, children: J.jsx(kw, {}) }),
    ],
  }),
);
