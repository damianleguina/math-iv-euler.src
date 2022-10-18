<template>
  <v-app>
    <v-main>
      <v-container fluid>
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field label="y'" v-model="func"></v-text-field>
          </v-col>
          <v-col cols="12" md="6">
            <v-text-field label="h" v-model.number="step"></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field
              label="x inicial"
              v-model.number="initialX"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              label="x final"
              v-model.number="finalX"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              label="y inicial"
              v-model.number="initialY"
            ></v-text-field>
          </v-col>
        </v-row>
        <v-row>
          <v-col cols="12" align="right">
            <v-btn class="mr-3" @click="onEvalEuler" color="primary">
              Euler
            </v-btn>
            <v-btn @click="onEvalImprovedEuler" color="primary">
              Euler Mejorado
            </v-btn>
          </v-col>
        </v-row>

        <template v-if="result.length > 0">
          <v-row>
            <h1>{{ title }}</h1>
          </v-row>
          <v-row>
            <v-col>
              <v-table>
                <thead>
                  <tr>
                    <th class="text-left">n</th>
                    <th class="text-left">x</th>
                    <th class="text-left">y</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(item, index) in result" :key="index">
                    <td>{{ index }}</td>
                    <td>{{ item.x }}</td>
                    <td>{{ item.y }}</td>
                  </tr>
                </tbody>
              </v-table>
            </v-col>
          </v-row>
        </template>
      </v-container>
    </v-main>
  </v-app>
</template>

<script setup lang="ts">

import { ref } from "vue";
import { BigNumber } from "mathjs";
import mathjs from "./math";

const result = ref<{ x: BigNumber; y: BigNumber }[]>([]);

const title = ref<"Euler" | "Euler Mejorado">("Euler");
const func = ref<string>("x + y ^ 2");
const step = ref<number>(0.1);
const initialX = ref<number>(0);
const finalX = ref<number>(1);
const initialY = ref<number>(0);

function evalFunc(x: BigNumber, y: BigNumber) {
  const scope = {
    x,
    y,
  };
  return mathjs.evaluate(func.value, scope);
}

function nextStep(x: BigNumber, h: BigNumber): BigNumber {
  return mathjs.add(x, h);
}

function euler(x: BigNumber, y: BigNumber, h: BigNumber): BigNumber {
  const f = evalFunc(x, y);
  const scope = {
    y,
    h,
    f,
  };
  return mathjs.evaluate("y + h * f", scope);
}

function improvedEuler(x: BigNumber, y: BigNumber, h: BigNumber): BigNumber {
  const f: BigNumber = evalFunc(x, y);
  const nextX: BigNumber = nextStep(x, h);
  const nextY: BigNumber = euler(x, y, h);
  const g = evalFunc(nextX, nextY);
  const scope = {
    y,
    h,
    f,
    g,
  };
  return mathjs.evaluate("y + ((h/2) * (f + g))", scope);
}

function onEval(eulerMethod: (x: BigNumber, y: BigNumber, h: BigNumber) => BigNumber): void {
  result.value = [];
  const h = mathjs.bignumber(step.value);
  let x = mathjs.bignumber(initialX.value);
  const limit = mathjs.bignumber(finalX.value);
  let y = mathjs.bignumber(initialY.value);

  let arr = [];
  while (x <= limit) {
    arr.push({ x, y });
    y = eulerMethod(x, y, h);
    x = nextStep(x, h);
  }
  console.table(arr);
  result.value = arr;
}

function onEvalEuler() {
  title.value = "Euler";
  onEval(euler);
}

function onEvalImprovedEuler() {
  title.value = "Euler Mejorado";
  onEval(improvedEuler);
}
</script>
