package;

import haxe.Json;
import haxe.io.Encoding;
import types.GraphTypes.Point;
import sys.io.File;

class Main {
	static function main() {
		final minTag = 0x01;
		final maxTag = 0xFE;
		var sp = ScatterPlot.fromRandom(100000, 0.1, maxTag, {
            minX: -5,
            maxX: 5,
            minY: -5,
            maxY: 5
        });
		Sys.println('Plot generated ${sp.getPlot().length} points, tagging                                               ');
		sp = Helpers.tagPoints(sp, minTag, maxTag, 0.25);
		Sys.println('Tagged ${sp.getPlot().length} points, writing output                                                ');
		final pts:Array<Array<{x:Float, y:Float}>> = [];
		for (tag in minTag...maxTag + 1) {
			if (sp.getPlot().filter(p -> p.tag == tag).length != 0)
				Sys.println('[$tag\t]${sp.getPlot().filter((pt) -> pt.tag == tag).map((k) -> return ".").join('')}');
			pts.push(sp.getPlot().filter(p -> p.tag == tag).map(pt -> return {x: pt.pos.x, y: pt.pos.y}));
		}
		final out = File.write('out.json', false);
		out.writeString(Json.stringify(pts, null, '\t'));
		out.flush();
		out.close();
	}
}
