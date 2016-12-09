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
    }) / (
    	res:MOVE_COMMANDS {
            return [res];
        }  / res: PEN_COMMANDS {
            return [res];
        }
    )

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
	= cmd:( FD / BK / RT / LT ) _ args:(ARGS _)+ {
    	if (Array.isArray(args)) {
          args = args.reduce(function(a, b) {
          	return a.concat(b);
          }).filter(function(item) {
          	return !Array.isArray(item) && item != null;
          });
        }
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
	= values:integer {
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

_ "whitespace" = ws:([ \t\n\r]*) {
  return null;
}