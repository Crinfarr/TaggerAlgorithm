package ;
import types.GraphTypes.Point;
import types.GraphTypes.Scatter;

private typedef FromRandomConfig = {
}

class ScatterPlot {
    private var plot:Scatter;
    
    public function new(points:Null<Scatter>) {
        if (points == null)
            points = [];
        this.plot = points;
    }

    public function addPoint(point:Point) {
        this.plot.push(point);
    }

    public function getPlot():Scatter {
        return this.plot;
    }

    public static function fromRandom(pointCount:Int, radius:Float, maxPerRadius:Int=63, randPtConfig:Null<{minX:Float, minY:Float, maxX:Float, maxY:Float}> = null):ScatterPlot {
        final sp = new ScatterPlot(null);
        for (_ in 0...pointCount) {
            var point:Point = {tag: null, pos: {x: 0.0, y: 0.0}};
            do {
                Sys.print('[${sp.getPlot().length}]\tTrying \t(${point.pos.x}, ${point.pos.y})          \r');
                if (randPtConfig != null) {
                    point = Helpers.randomPoint(randPtConfig.minX, randPtConfig.maxX, randPtConfig.minY, randPtConfig.maxY);
                    continue;
                }
                point = Helpers.randomPoint();
			} while (!Helpers.checkFreePointInRadius(point, sp.getPlot(), 63, radius));
            sp.addPoint(point);
        }
        return sp;
    }
}