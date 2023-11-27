package;

import haxe.Exception;
import haxe.macro.Expr.Error;
import haxe.display.Display.Package;
import haxe.ds.Vector;
import types.GraphTypes.Scatter;
import types.GraphTypes.Point;

private typedef RandomGraphConfig = {
	radius:Int,
	maxPoints:Null<Int>,
	totalPoints:Int
};

class Helpers {
	public static function linearDistance(pt1:Point, pt2:Point):Float {
		return Math.sqrt(Math.pow(pt1.pos.x - pt2.pos.x, 2) + Math.pow(pt1.pos.y - pt2.pos.y, 2)); // the pythagorean theorem
	}

	public static function checkFreePointInRadius(center:Point, points:Scatter, max:Int, radius:Float):Bool {
		var inRadius:Int = 0;
        if (points.length == 0) {
            return true;
        }
		for (point in points) {
			if (linearDistance(point, center) <= radius) {
				inRadius++;
			}
			if (inRadius >= max) {
				return false;
			}
		}
		return true;
	}

	public static function randomPoint(minX:Float = -180, maxX:Float = 180, minY:Float = -90, maxY:Float = 90):Point {
		return {
			tag: null,
			pos: {
				x: Math.random() * (maxX - minX) + minX,
				y: Math.random() * (maxY - minY) + minY
			}
		};
	}

	public static function tagPoints(plot:ScatterPlot, minTag:Int = 0x01, maxTag:Int = 0xFE, radius:Float):ScatterPlot {
		final graph = plot.getPlot();
		final taggedGraph = new ScatterPlot(null);
		while (graph.length != 0) {
            final pt = graph.splice(0,1)[0];
            if (pt == null) {
                trace("Null point, ignoring");
                continue;
            }
            for (tag in minTag...maxTag+1) {
                if (!checkFreePointInRadius(pt, taggedGraph.getPlot().filter((pt) -> pt.tag == tag), 1, radius)) {
					continue;
                }
                Sys.print('[${taggedGraph.getPlot().length}\t]tagged point\t${tag}    \r');
                pt.tag = tag;
                break;
            }
            if (pt.tag == null) {
                throw new Exception("Can't tag point "+pt);
            }
            taggedGraph.addPoint(pt);
        }
		return taggedGraph;
	}
}
