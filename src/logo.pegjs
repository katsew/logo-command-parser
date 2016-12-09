{
	var flatten = function (arr) {
        return arr.reduce(function(a, b) {
	        return Array.isArray(b) ? a.concat(flatten(b)) : a.concat(b);
        }, []).filter(function(item) {
	        return !Array.isArray(item) && item != null && item !== "\n";
        });
    };
}

START
	= res:(LOGO+) {
        return flatten(res);
    }
    
LOGO
	= expr:EXPR "\n" ? {
    	return expr;
  	} / "\n"
    
EXPR
	= (res:REPEAT {
        if (Array.isArray(res)) {
        	res = flatten(res);
        }
        return res;
    }) / (res:FOR {
        if (Array.isArray(res)) {
        	res = flatten(res);
        }
        return res;
    }) / (
    	res:MOVE_COMMANDS {
            return [res];
        }  / res: PEN_COMMANDS {
            return [res];
        }
    )
    
FOR
	= ("FOR") _ "["_ ident:string _ start:integer _ stop:integer _ step:integer  _ "][" expr:( _ EXPR _ / "\n") + "]" {
    	var transformed = flatten(expr);
		var results = [];
        for (var i = start; i < stop + 1; i = i + step) {
        	var mapped = transformed.map(function(item) {
            	var cloned = Object.assign({}, item);                
            	if (cloned.args && Array.isArray(cloned.args)) {
                  cloned.args = cloned.args.map(function(arg) {
                  	return arg === ident ? i : arg;
                  });
                }
                return cloned;
            });
        	results.push(mapped);
        }
        console.log(results);
        return results;
    }

REPEAT
	= ("RP" / "REPEAT")  _ count:integer _ "[" expr:( _ EXPR _ / "\n") +  "]" {
        if (Array.isArray(expr) && expr.length > 1) {
        	expr = flatten(expr);
        }
		var results = [];
        for (var i = 0; i < count; ++i) {
        	results.push(expr);
        }
    	return results;
    }

MOVE_COMMANDS
	= cmd:( FD / BK / RT / LT ) _ args:(ARGS)+ {
    	args = flatten(args);
		return {
          "command": cmd,
          "args": args
        };
    }

PEN_COMMANDS
	= cmd:( PU / PD ) _ {
		return {
          "command": cmd,
          "args": []
        };
    }
    
ARGS
	= values:(integer/string) {
    	return values;
    }

FD
  = "FD" / "FORWARD"
    
BK
	= "BK" / "BACKWARD"
    
PU
	= "PU" / "PENUP"

PD
	= "PD" / "PENDOWN"
    
RT
	= "RT" / "RIGHT"

LT
	= "LT" / "LEFT"

integer
	= digits:[0-9]+ { return parseInt(digits.join(""), 10); }
    
string
	= chars:[a-zA-Z]+ { return chars.join(""); }

_ "whitespace" = ws:([ \t\n\r]*) {
  return null;
}