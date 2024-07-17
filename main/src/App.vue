<template>
  <div class="mt-4 text-center no-print">
    <el-input
      v-model="token"
      class="w-2/3"
      placeholder="Slackのアプリトークンを入力してください"
    />
    <el-button class="ml-2" type="primary" @click="fetchUserList"
      >送信</el-button
    >
  </div>
  <div v-loading="loading" class="mt-10">
    <template v-if="slackApiError">
      <el-result icon="error" title="エラーが発生しました">
        <template #extra> メッセージ：{{ slackApiError }} </template>
      </el-result>
    </template>
    <template v-else-if="result?.error">
      <el-result icon="error" title="エラーが発生しました">
        <template #extra> メッセージ：{{ result?.error }} </template>
      </el-result>
    </template>
    <template v-else-if="result">
      <div class="m-4 no-print">
        <p>メンバー数：{{ result.length }}</p>
        <span>画像サイズ</span
        ><el-input v-model="iconSize" class="w-12 ml-2" />px
        <span class="ml-4">縦余白</span
        ><el-input v-model="yohakuY" class="w-12 ml-2" />px
        <span class="ml-2">横余白</span
        ><el-input v-model="yohakuX" class="w-12 ml-2" />px
        <span class="ml-4">行間隙間</span
        ><el-input v-model="gridGapRow" class="w-12 ml-2" />px
        <span class="ml-2">列間隙間</span
        ><el-input v-model="gridGapColumn" class="w-12 ml-2" />px
        <span class="ml-4">名前を付ける</span
        ><el-switch v-model="showName" class="w-12 ml-2" />
        <hr class="mt-4" />
      </div>
      <div :style="pageStyleObject" class="page">
        <ul class="grid" :style="gridStyleObject">
          <li v-for="user in result" :key="user.id" class="">
            <div>
              <el-image :src="user.image_512" fit="fill" style="width: 100%" />
            </div>
            <div v-if="showName">{{ user.real_name }}</div>
          </li>
        </ul>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from "vue";
import axios from "axios";

const token = ref<string>("");
const loading = ref<boolean>(false);
const result = ref<any>(undefined);
const slackApiError = ref<any>(undefined);
const yohakuY = ref<number>(10);
const yohakuX = ref<number>(10);
const gridGapColumn = ref<number>(10);
const gridGapRow = ref<number>(10);
const showName = ref<boolean>(false);
const iconSize = ref<number>(200);
const pageStyleObject = computed(() => ({
  padding: `${yohakuY.value}px ${yohakuX.value}px`,
}));
const gridStyleObject = computed(() => ({
  gap: `${gridGapRow.value}px ${gridGapColumn.value}px`,
  "grid-template-columns": `repeat(auto-fit, minmax(${iconSize.value}px, 1fr))`,
}));
onMounted(() => {});

// SlackAPIを叩いてユーザ一覧を取得する
const fetchUserList = async () => {
  loading.value = true;

  axios({
    method: "post",
    url: "https://slack.com/api/users.list",
    data: `token=${token.value}`,
  })
    .then((response: any) => {
      const members = response.data?.members;
      if (members && members.length > 0) {
        console.log(members);
        result.value = members
          .filter(
            (member: any) =>
              member.deleted == false &&
              member.is_bot == false &&
              member.is_restricted == false
          )
          .map((member: any) => ({
            id: member.id,
            name: member.name,
            real_name: member.name,
            image_512: member.profile?.image_512,
            display_name: member.profile?.display_name,
          }));
      } else {
        slackApiError.value = "メンバーが1人もいませんでした";
      }
    })
    .catch((error: any) => {
      slackApiError.value = error;
    });

  loading.value = false;
};
</script>
<style scoped>
/* A4縦用のベース設定 */
@page {
  size: A4 portrait; /* 横の場合はlandscape */
  margin: 0mm;
}

/* 印刷時の調子を整える */
body {
  width: 210mm; /* 用紙の横幅を改めて指定 Chrome用 */
  -webkit-print-color-adjust: exact;
  color-adjust: exact;
  line-height: 1.5em;
}

/* 印刷1ページ用のコンテンツはここで定義 */
.page {
  width: 210mm; /* 用紙の横幅を改めて指定 */
  page-break-after: always;

  box-sizing: border-box;
  padding: 20mm 25mm; /* 用紙の余白 */
}

@media print {
  .no-print {
    display: none;
  }
}

@media screen {
  body {
    background: #eee;
  }
  .page {
    background: white; /* 背景を白く */
    box-shadow: 0 0.5mm 3mm rgba(0, 0, 0, 0.3); /* ドロップシャドウ */
    margin: auto;
  }
}
</style>
