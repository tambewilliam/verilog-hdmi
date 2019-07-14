module console (
           input wire CLK_PIXEL,
           input wire [7:0] character,
           input wire [7:0] attribute,
           input wire [9:0] cx,
           input wire [9:0] cy,

           output reg [23:0] rgb
       );

wire [127:0] characterraster;
charactermap charactermap(.character(character), .characterraster(characterraster));

wire [23:0] fgrgb, bgrgb;
wire blink;
attributemap attributemap(.attribute(attribute), .fgrgb(fgrgb), .bgrgb(bgrgb), .blink(blink));

reg [9:0] prevcy = 0;
reg [3:0] vindex = 0;
reg [2:0] hindex = 0;
always @(posedge CLK_PIXEL)
begin
    if (cx == 0 && cy == 0)
    begin
        prevcy <= 0;
        vindex = 0;
        hindex = 0;
    end
    else if (prevcy != cy)
    begin
        prevcy <= cy;
        vindex = vindex + 1'b1;
        hindex = 0;
    end
    else
    begin
        hindex = hindex + 1'b1;
    end
    rgb = characterraster[{~vindex, ~hindex}] ? fgrgb : bgrgb;
end
endmodule