<template>
    <section class="login" v-show="!loggedIn">
        <div id="alert" v-if="alert">{{ alert }}</div>

        <form @submit.prevent="login">
            <label>
                Username
                <input type="text" v-model="username" />
            </label>
            <label>
                Password
                <input type="password" v-model="password" />
            </label>
            <button type="submit">Log in</button>
        </form>
    </section>
    <Demo v-show="loggedIn"/>
</template>

<script lang="js">
import Demo from './Demo.vue'

export default {
    components: {
    Demo
    },
    data() {
        return {
            username: "",
            password: "",
            alert: "",
            loggedIn: false,
        };
    },
    methods: {
        login() {
            this.alert = "";
            console.log("pw", process.env.PASSWORD);
            if (username === "admin" && password === process.env.PASSWORD)
            {
                this.loggedIn = true;
            }
            else {
                this.username = "";
                this.password = "";
                this.alert = "Invalid login";
            };
        }
    },
};
</script>