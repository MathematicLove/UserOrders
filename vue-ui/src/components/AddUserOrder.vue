<template>
  <div class="p-6 max-w-lg mx-auto space-y-6">
    <h1 class="text-3xl font-bold text-center">User & Order Manager</h1>

    <!-- Add User -->
    <section class="space-y-2 border p-4 rounded-xl shadow">
      <h2 class="font-semibold text-xl">Add User</h2>
      <input v-model="username" placeholder="Username" class="input" />
      <input v-model="email" placeholder="Email" class="input" />
      <button @click="addUser" class="btn">Add User</button>
    </section>

    <!-- Add Order -->
    <section class="space-y-2 border p-4 rounded-xl shadow">
      <h2 class="font-semibold text-xl">Add Order</h2>
      <input v-model="orderName" placeholder="Order name" class="input" />
      <input v-model.number="orderAmount" type="number" placeholder="Amount" class="input" />
      <button @click="addOrder" class="btn" :disabled="!userId">Add Order</button>
    </section>

    <!-- Status Log -->
    <div v-if="log" class="bg-gray-100 p-4 rounded text-sm">
      <strong>Status:</strong>
      <pre>{{ log }}</pre>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const username = ref('')
const email = ref('')
const orderName = ref('')
const orderAmount = ref(0)
const userId = ref(null)
const log = ref('')

const apiBase = 'http://localhost:3000/api' // Rails API

async function addUser() {
  const res = await fetch(`${apiBase}/users`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ user: { username: username.value, email: email.value } })
  })

  const data = await res.json()
  if (res.ok) {
    log.value = `User added: ${JSON.stringify(data, null, 2)}`
    userId.value = data.user_id
  } else {
    log.value = `Error: ${JSON.stringify(data, null, 2)}`
  }
}

async function addOrder() {
  const res = await fetch(`${apiBase}/orders`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      order: {
        user_id: userId.value,
        order_name: orderName.value,
        amount: orderAmount.value
      }
    })
  })

  const data = await res.json()
  if (res.ok) {
    log.value = `Order added: ${JSON.stringify(data, null, 2)}`
  } else {
    log.value = `Error: ${JSON.stringify(data, null, 2)}`
  }
}
</script>

<style scoped>
.input {
  display: block;
  width: 100%;
  padding: 0.5rem;
  margin-bottom: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 0.375rem;
}
.btn {
  padding: 0.5rem 1.25rem;
  background-color: black;
  color: white;
  border-radius: 0.375rem;
  border: none;
  cursor: pointer;
}
.btn:disabled {
  background-color: #94a3b8;
  cursor: not-allowed;
}
</style>
