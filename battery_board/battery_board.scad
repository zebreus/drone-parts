mainDistance = 150;

screwDistance = 6;
boardDepth = 20;
boardHeight = 4.5;
screwDiameter = 2.5;

legAngle = 30;
legWidth = 10;
boardWidth = mainDistance + boardDepth;

batteryWidth = 77.5;
batteryDepth = 38;
batteryHeight = 42;

angle = 45;
holderSize = 13;
height = batteryHeight / 2;

minRadius = batteryDepth / 3.5;
maxRadius = batteryDepth / 2.5;

batteryOffset = -6;
batteryAngle = -40;

stepsBase = 3;
ringsBase = 6;
module mirror_copy(vector)
{
    children();
    mirror(vector) children();
}

module RingThing(radius, angle = 40, holderSize = 10)
{
    translate([ 0, -radius + boardHeight, 0 ]) mirror([ 1, 0, 0 ]) rotate([ 0, 0, 90 ]) rotate([ -90, 0, 0 ]) union()
    {

        difference()
        {
            cylinder($fs = 0.1, $fa = 5, h = boardHeight, r = radius);
            translate([ 0, 0, -1 ]) cylinder($fs = 0.1, $fa = 5, h = boardHeight + 2, r = radius - boardHeight);
            translate([ -radius, 0, -1 ]) cube([ radius * 2, radius * 2, boardHeight + 2 ]);
            rotate([ 0, 0, 90 + angle ]) translate([ 0, 0, -1 ]) cube([ radius * 2, radius * 2, boardHeight + 2 ]);
        }
        difference()
        {
            stickLength = tan(angle) * radius + radius;
            rotate([ 0, 0, -(180 - angle) ]) translate([ radius - boardHeight, 0, 0 ]) mirror([ 0, 1, 0 ])
                cube([ boardHeight, stickLength + radius, boardHeight ]);
            translate([ -stickLength * 4, 0, -stickLength * 2 ])
                cube([ stickLength * 4, stickLength * 4, stickLength * 4 ]);
        }
        weirdValue = (tan(angle) * radius) + (radius - (radius * sin(angle))) - (boardHeight * sin(45));
        translate([ -weirdValue, 0, boardHeight / 2 ]) rotate([ 0, -135, 0 ]) mirror([ 0, 1, 0 ])
        {
            cube([ holderSize, boardHeight, holderSize ]);
            rotate([ 0, 45, 0 ]) translate([ -boardHeight / 2, 0, -tan(angle) * boardHeight / 2 ])
                cube([ boardHeight, boardHeight, holderSize ]);
        }
    }
}

module RingThingWithBase(radius)
{
    translate([ 0, 0, height ]) RingThing(radius, angle, holderSize);
    cube([ boardHeight, boardHeight, height ]);
}

batteryClipSize = 4.5;
batteryClipAngle = 50;
batteryClipAnchor = 10;
batteryClipHeight = 2;
batteryClipWidth = batteryWidth / 1.6;

module MainBoard()
{
    difference()
    {
        union()
        {
            difference()
            {
                union()
                {
                    translate([ 0, boardDepth, boardHeight / 2 ]) rotate([ batteryAngle, 0, 0 ])
                        translate([ 0, -boardDepth, -boardHeight / 2 ])
                    {
                        translate([ -boardWidth / 2, 0, 0 ]) cube([ boardWidth, boardDepth, boardHeight ]);
                        mirror_copy([ 1, 0, 0 ]) translate([ -batteryWidth / 2, boardDepth, boardHeight / 2 ])
                            rotate([ 90, 0, 0 ])
                        {
                            translate([ 0, 0, -99 ]) cylinder(r = batteryDepth / 4, h = boardHeight + 99);
                            translate([ 0, 0, boardHeight ])
                                cylinder(r1 = batteryDepth / 4, r2 = boardHeight / 2, h = boardDepth - boardHeight);
                        }
                    }
                    translate([ 0, 0, batteryOffset ])
                    {
                        translate([ 0, 0, boardHeight / 2 ]) mirror_copy([ 0, 0, 1 ]) translate(
                            [ 0, 0, -boardHeight / 2 ])

                            translate(
                                [ -batteryClipWidth / 2, boardDepth - boardHeight, (-batteryHeight + boardHeight) / 2 ])
                                mirror([ 0, 1, 0 ]) translate([ 0, 0, -boardHeight ]) difference()
                        {
                            translate([ 0, batteryDepth - batteryClipAnchor, 0 ]) cube([
                                batteryClipWidth,
                                batteryClipAnchor + batteryClipHeight +
                                    (tan(batteryClipAngle) * (boardHeight + batteryClipSize)),
                                boardHeight +
                                batteryClipSize
                            ]);
                            translate([
                                0,
                                batteryDepth + batteryClipHeight +
                                    (tan(batteryClipAngle) * (boardHeight + batteryClipSize)),
                                0
                            ]) rotate([ batteryClipAngle, 0, 0 ]) cube([ batteryClipWidth, batteryClipWidth, 999999 ]);
                        }
                    }
                    translate([ 0, 0, batteryOffset ]) translate([ 0, boardDepth - boardHeight, boardHeight / 2 ])
                    {
                        translate([ -batteryWidth / 2, 0, -batteryHeight / 4 ])
                            cube([ batteryWidth, boardHeight, batteryHeight / 2 ]);

                        mirror_copy([ 1, 0, 0 ]) mirror_copy([ 0, 0, 1 ])
                        {
                            translate([ -boardHeight / 2, 0, 0 ]) for (r = [1:stepsBase])
                            {
                                progress = (r - 1) / (stepsBase - 1);
                                radius = minRadius + (maxRadius - minRadius) * progress * (stepsBase / (stepsBase + 1));
                                translate([ ((batteryWidth / 4)) * progress, 0, 0 ]) RingThingWithBase(radius);
                            }
                            translate([ batteryWidth / 4, 0, 0 ]) for (r = [2:ringsBase]) if (r != 3)
                            {
                                progress = (r - 1) / (ringsBase - 1);
                                radius =
                                    r > 3 ? minRadius : maxRadius; // minRadius + (maxRadius - minRadius) * progress;
                                translate([ progress * ((batteryWidth / 4) - (batteryDepth / 2)), 0, 0 ])
                                    rotate(a = progress * 90, v = [ 0, 1, 0 ]) translate([ -boardHeight / 2, 0, 0 ])
                                        RingThingWithBase(radius);
                            }
                        }

                        // cylinder(h = h, r = r);
                    }
                }

                translate([ 0, boardDepth, boardHeight / 2 ]) rotate([ batteryAngle, 0, 0 ])
                    translate([ 0, -boardDepth, -boardHeight / 2 ]) mirror_copy([ 1, 0, 0 ])
                        translate([ mainDistance / 2, screwDistance, 0 ]) rotate([ 0, 0, legAngle ])
                            translate([ legWidth / 2, -mainDistance / 2, 0 ])
                                cube([ mainDistance, mainDistance, mainDistance ]);

                translate([ 0, 0, batteryOffset ]) translate([ 0, boardDepth - boardHeight, boardHeight / 2 ])
                    translate([ -batteryWidth / 2, -batteryDepth, -batteryHeight / 2 ])
                        cube([ batteryWidth, batteryDepth, batteryHeight ]);
                translate([ -999 / 2, boardDepth, -999 / 2 ]) cube([ 999, 999, 999 ]);

                translate([ 0, 0, boardHeight / 2 + batteryOffset ]) mirror_copy([ 0, 0, 1 ]) translate([
                    -batteryWidth / 2,
                    boardDepth - boardHeight - batteryDepth -
                        ((tan(batteryClipAngle) * (boardHeight + batteryClipSize))) - batteryClipHeight,
                    batteryHeight / 2 +
                    boardHeight
                ]) rotate([ batteryClipAngle + 180, 0, 0 ])
                    cube([
                        batteryWidth, (sin(batteryClipAngle) * (boardHeight + batteryClipSize)),
                        sqrt((tan(batteryClipAngle) * (boardHeight + batteryClipSize)) ^
                             2 + (sin(batteryClipAngle) * (boardHeight + batteryClipSize)) ^ 2) +
                            5
                    ]);
            }
        }
    }
}

difference()
{
    MainBoard();

    translate([ 0, boardDepth, boardHeight / 2 ]) rotate([ batteryAngle, 0, 0 ])
        translate([ 0, -boardDepth, -boardHeight / 2 ]) mirror_copy([ 1, 0, 0 ])
    {
        translate([ -mainDistance / 2, screwDistance, 0 ])
            cylinder($fs = 0.1, $fa = 5, h = boardHeight, d = screwDiameter);
    }
}