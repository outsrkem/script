from pyecharts.charts import Bar

bar = Bar()
bar.add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])
bar.add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
bar.render("index.html")

from pyecharts.charts import Bar
bar = (
    Bar()
    .add_xaxis(["衬衫", "羊毛衫", "雪纺衫", "裤子", "高跟鞋", "袜子"])
    .add_yaxis("商家A", [5, 20, 36, 10, 75, 90])
)
bar.render("index.html")
"""
from pyecharts.charts import Bar,Line
from pyecharts import options as opts
from pyecharts.globals import ThemeType
bar = (
    Bar(init_opts=opts.InitOpts(theme=ThemeType.LIGHT))
    .add_xaxis(["1", "2", "3", "4", "5", "6", "2", "3", "4", "5", "6", "2", "3", "4", "5", "6", "2", "3", "4", "5", "6"])
    .add_yaxis("CPU", [5, 20, 36, 10, 75, 90, 20, 36, 10, 75, 90, 20, 36, 10, 75, 90, 20, 36, 10, 75, 190])
    .add_yaxis("内存", [15, 6, 45, 20, 35, 66, 6, 45, 20, 35, 66, 6, 45, 20, 35, 66, 6, 45, 20, 35, 66])
    .add_yaxis("磁盘", [15, 6, 45, 20, 35, 66, 6, 45, 20, 35, 66, 6, 45, 20, 35, 66, 6, 45, 20, 35, 66])
    .set_global_opts(title_opts=opts.TitleOpts(title="系统负载", subtitle="副标题"))
)
bar.render("index.html")
"""
#报错
#导入案例数据集
from example.commons import Faker 
from pyecharts import options as opts
from pyecharts.charts import Bar, Grid, Line,Scatter
line = (
    Line()
    .add_xaxis(Faker.choose())
    .add_yaxis("商家A", Faker.values())
    .add_yaxis("商家B", Faker.values())
    .set_global_opts(
        title_opts=opts.TitleOpts(title="Grid-Line", pos_top="48%"), #pos_top ='48%' 距离上侧且为容器高度的48%，
        legend_opts=opts.LegendOpts(pos_top="48%"),#图例配置项
    )
line.render()



# 报错
#导入案例数据集


from example.commons import Faker 
from pyecharts import options as opts
from pyecharts.charts import Bar, Grid, Line,Scatter
def grid_vertical() -> Grid:
    bar = (
        Bar()
        .add_xaxis(Faker.choose())
        .add_yaxis("商家A", Faker.values())
        .add_yaxis("商家B", Faker.values())
        .set_global_opts(title_opts=opts.TitleOpts(title="Grid-Bar")) #全局配置--标题配置
    )
    line = (
        Line()
        .add_xaxis(Faker.choose())
        .add_yaxis("商家A", Faker.values())
        .add_yaxis("商家B", Faker.values())
        .set_global_opts(
            title_opts=opts.TitleOpts(title="Grid-Line", pos_top="48%"), #pos_top ='48%' 距离上侧且为容器高度的48%，
            legend_opts=opts.LegendOpts(pos_top="48%"),#图例配置项
        )
    )
    grid = (
        Grid()
        .add(bar, grid_opts=opts.GridOpts(pos_bottom="60%"))
        .add(line, grid_opts=opts.GridOpts(pos_top="60%"))
    )
    return grid
grid_vertical().render()





from pyecharts.charts import Bar,Line
from pyecharts import options as opts
from pyecharts.globals import ThemeType
bar = (
    Bar(init_opts=opts.InitOpts(theme=ThemeType.LIGHT))
    .add_xaxis(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "17", "19", "20", "21"])
    .add_yaxis("cpu",[5, 20, 36, 10, 75, 90, 20, 36, 10, 75, 90, 20, 36, 10, 75, 90, 20, 36, 10, 75, 190])
    .set_global_opts(title_opts=opts.TitleOpts(title="系统负载", subtitle="副标题"))
)
bar.render("index.html")
