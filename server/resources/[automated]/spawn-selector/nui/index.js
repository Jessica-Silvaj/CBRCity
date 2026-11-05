var App = new Vue({
    el: '#app',
    data: {
        menu: 0,
        places: [
        ],
        showingPlaces: [
        ],
        personalInfo: {
            lastLocation: '1577.47,578887.1477,1488.1000',
        },
        animationL: false,
        animationR: false,
        spawnAnimation: false,

    },

    methods: {
        loadSpawners(data) {
            this.loadInfos()
        },
        loadInfos() {

            this.showingPlaces.splice(0, this.showingPlaces.length);
            this.showingPlaces.push(this.places[0], this.places[1], this.places[2])
        },
        changeInfos(index) {
            if (index == 0) {
                this.animationL = true
            } else if (index == 2) {
                this.animationR = true
            } else if (index == 1) {
                return 0;
            }
            setTimeout(() => {
                if (index == 2) {
                    let firstElement = this.places.shift()
                    this.places.push(firstElement)
                    this.loadInfos()
                } else if (index == 0) {
                    let lastElement = this.places.pop()
                    this.places.splice(0, 0, lastElement)
                    this.loadInfos()
                } else if (index == 1) {
                    return 0;
                }

                this.animationL = false
                this.animationR = false
            }, "900")
        },
        spawn() {
            this.spawnAnimation = true
            //let spawnLocation = this.showingPlaces[1].coords

            setTimeout(() => {
                this.menu = 0
            }, "900")
            axios.post('http://spawn-selector/selectSpawn', {
                mode: 1,
                coord: this.showingPlaces[1].coords
            })
        },
        openMenu(lastCoord, spawners) {
            this.menu = 1
            this.places = spawners
            this.loadInfos(lastCoord)
        },
        spawnLastLocation() {
            this.spawnAnimation = true


            setTimeout(() => {
                this.menu = 0
            }, "900")
            axios.post('http://spawn-selector/selectSpawn', {
                mode: 0,
            })
        }
    },
    mounted() {



        window.addEventListener('message', ({ data }) => {
            if (!data) return
            const [name, ...args] = data;
            if (!App[name]) return
            App[name](...args)
        })
    },
})