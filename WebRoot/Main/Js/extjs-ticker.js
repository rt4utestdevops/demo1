Ext.ux.Ticker = Ext.extend(Ext.BoxComponent, {
    baseCls: 'x-ticker',
    autoEl: {
        tag: 'div',
        cls: 'x-ticker-wrap',
        children: {
            tag: 'div',
            cls: 'x-ticker-body'
        }
    },
    body: null,

    constructor: function(config) {
        Ext.applyIf(config, {
            direction: 'up',
            speed: 1,
            pauseOnHover: true
        });
        if (config.speed < 1) config.speed = 1;
        else if (config.speed > 20) config.speed = 20;

        Ext.applyIf(config, {
            refreshInterval: parseInt(10 / config.speed * 15)
        });
        config.unitIncrement = 1;

        Ext.ux.Ticker.superclass.constructor.call(this, config);

        this.addEvents('itemclick');
    },

    afterRender: function() {
        this.body = this.el.first('.x-ticker-body');
        this.body.addClass(this.direction);

        this.taskCfg = {
            interval: this.refreshInterval,
            scope: this
        };

        var posInfo, body = this.body;
        switch (this.direction) {
            case "left":
            case "right":
                posInfo = { left: body.getWidth() };
                this.taskCfg.run = this.scroll.horz;
                break;
            case "up":
            case "down":
                posInfo = { top: body.getHeight() };
                this.taskCfg.run = this.scroll.vert;
                break;
        }
        posInfo.position = 'relative';

        body.setPositioning(posInfo);
        Ext.ux.Ticker.superclass.afterRender.call(this);

        if (this.pauseOnHover) {
            this.el.on('mouseover', this.onMouseOver, this);
            this.el.on('mouseout', this.onMouseOut, this);
            this.el.on('click', this.onMouseClick, this);
        }

        this.task = Ext.apply({}, this.taskCfg);
        Ext.TaskMgr.start(this.task);
    },

    add: function(o) {
        var dom = Ext.DomHelper.createDom(o);
        this.body.appendChild(Ext.fly(dom).addClass('x-ticker-item').addClass(this.direction));
    },

    onDestroy: function() {
        if (this.task) {
            Ext.TaskMgr.stop(this.task);
        }

        Ext.ux.Ticker.superclass.onDestroy.call(this);
    },

    onMouseOver: function() {
        if (this.task) {
            Ext.TaskMgr.stop(this.task);
            delete this.task;
        }
    },

    onMouseClick: function(e, t, o) {
        var item = Ext.fly(t).up('.x-ticker-item');
        if (item) {
            this.fireEvent('itemclick', item, e, t, o);
        }
    },

    onMouseOut: function() {
        if (!this.task) {
            this.task = Ext.apply({}, this.taskCfg);
            Ext.TaskMgr.start(this.task);
        }
    },

    scroll: {
        horz: function() {
            var body = this.body;
            var bodyLeft = body.getLeft(true);
            if (this.direction == 'left') {
                var bodyWidth = body.getWidth();
                if (bodyLeft <= -bodyWidth) {
                    bodyLeft = this.el.getWidth(true);
                } else {
                    bodyLeft -= this.unitIncrement;
                }
            } else {
                var elWidth = this.el.getWidth(true);
                if (bodyLeft >= elWidth) {
                    bodyLeft = -body.getWidth(true);
                } else {
                    bodyLeft += this.unitIncrement;
                }
            }
            body.setLeft(bodyLeft);
        },

        vert: function() {
            var body = this.body;
            var bodyTop = body.getTop(true);
            if (this.direction == 'up') {
                var bodyHeight = body.getHeight(true);
                if (bodyTop <= -bodyHeight) {
                    bodyTop = this.el.getHeight(true);
                } else {
                    bodyTop -= this.unitIncrement;
                }
            } else {
                var elHeight = this.el.getHeight(true);
                if (bodyTop >= elHeight) {
                    bodyTop = -body.getHeight(true);
                } else {
                    bodyTop += this.unitIncrement;
                }
            }
            body.setTop(bodyTop);
        }
    }
});
