<template>
	<div
		class="flex h-full flex-col justify-between transition-all duration-300 ease-in-out border-e bg-surface-sidebar overflow-x-hidden"
		:class="sidebarStore.isSidebarCollapsed ? 'w-14' : 'w-56'"
	>
		<div
			class="flex flex-col overflow-y-auto flex-1 min-h-0"
			:class="sidebarStore.isSidebarCollapsed ? 'items-center' : ''"
		>
			<UserDropdown :isCollapsed="sidebarStore.isSidebarCollapsed" />
			<div class="flex flex-col" v-if="sidebarSettings.data">
				<div v-for="link in sidebarLinks" class="mx-2 my-2.5">
					<div
						v-if="!link.hideLabel"
						class="mb-2 mt-3 flex cursor-pointer gap-1.5 px-1 text-base-medium text-ink-gray-5 transition-all duration-300 ease-in-out"
					>
						<span>{{ __(link.label) }}</span>
					</div>
					<nav class="space-y-1">
						<div v-for="item in link.items">
							<SidebarLink
								:link="item"
								:isCollapsed="sidebarStore.isSidebarCollapsed"
							/>
						</div>
					</nav>
				</div>
				<div class="mx-2 my-2.5">
					<nav class="space-y-1">
						<button
							class="flex w-full cursor-pointer items-center rounded text-ink-gray-8 duration-300 ease-in-out hover:bg-surface-gray-2 focus:outline-none focus:transition-none focus-visible:rounded focus-visible:ring-2 focus-visible:ring-outline-gray-3"
							:class="sidebarStore.isSidebarCollapsed ? 'h-7' : 'min-h-10'"
							@click="showPosterModal = true"
						>
							<div
								class="flex items-center w-full duration-300 ease-in-out"
								:class="
									sidebarStore.isSidebarCollapsed ? 'p-1 relative' : 'px-2 py-1'
								"
							>
								<Tooltip
									:text="projectTitle"
									placement="right"
									:disabled="!sidebarStore.isSidebarCollapsed"
								>
									<span class="grid h-5 w-6 flex-shrink-0 place-items-center">
										<Landmark class="h-4 w-4 stroke-1.5 text-ink-gray-8" />
									</span>
								</Tooltip>
								<span
									class="ms-2 min-w-0 text-start text-sm leading-5 duration-300 ease-in-out"
									:class="
										sidebarStore.isSidebarCollapsed
											? 'w-0 overflow-hidden opacity-0'
											: 'w-full opacity-100'
									"
								>
									<span class="whitespace-normal break-all">
										{{ projectTitle }}
									</span>
								</span>
							</div>
						</button>
						<button
							class="flex w-full cursor-pointer items-center rounded text-ink-gray-8 duration-300 ease-in-out hover:bg-surface-gray-2 focus:outline-none focus:transition-none focus-visible:rounded focus-visible:ring-2 focus-visible:ring-outline-gray-3"
							:class="sidebarStore.isSidebarCollapsed ? 'h-7' : 'min-h-10'"
							@click="showLicenseModal = true"
						>
							<div
								class="flex items-center w-full duration-300 ease-in-out"
								:class="
									sidebarStore.isSidebarCollapsed ? 'p-1 relative' : 'px-2 py-1'
								"
							>
								<Tooltip
									:text="licenseTitle"
									placement="right"
									:disabled="!sidebarStore.isSidebarCollapsed"
								>
									<span class="grid h-5 w-6 flex-shrink-0 place-items-center">
										<FileText class="h-4 w-4 stroke-1.5 text-ink-gray-8" />
									</span>
								</Tooltip>
								<span
									class="ms-2 min-w-0 text-start text-sm leading-5 duration-300 ease-in-out"
									:class="
										sidebarStore.isSidebarCollapsed
											? 'w-0 overflow-hidden opacity-0'
											: 'w-full opacity-100'
									"
								>
									<span class="whitespace-pre-line break-words">
										{{ licenseTitle }}
									</span>
								</span>
							</div>
						</button>
					</nav>
				</div>
			</div>
			<div
				v-if="sidebarSettings.data?.web_pages?.length || isModerator"
				class="mt-4"
			>
				<div
					class="flex items-center justify-between pe-2 cursor-pointer"
					:class="sidebarStore.isSidebarCollapsed ? 'ps-3' : 'ps-4'"
					@click="toggleWebPages"
				>
					<div
						v-if="!sidebarStore.isSidebarCollapsed"
						class="flex items-center text-ink-gray-5 my-1"
					>
						<span class="grid h-5 w-6 flex-shrink-0 place-items-center">
							<span
								class="lucide-chevron-right h-4 w-4 text-ink-gray-9 transition-all duration-300 ease-in-out"
								:class="{
									'rotate-90': !sidebarStore.isWebpagesCollapsed,
									'rtl:rotate-180': sidebarStore.isWebpagesCollapsed,
								}"
							/>
						</span>
						<span class="ms-2">
							{{ __('More') }}
						</span>
					</div>
					<Button
						v-if="isModerator && !readOnlyMode"
						variant="ghost"
						@click="openPageModal()"
					>
						<template #icon>
							<span class="lucide-plus h-4 w-4 text-ink-gray-7" />
						</template>
					</Button>
				</div>
				<div
					v-if="sidebarSettings.data?.web_pages?.length"
					class="flex flex-col transition-all duration-300 ease-in-out"
					:class="!sidebarStore.isWebpagesCollapsed ? 'block' : 'hidden'"
				>
					<div
						v-for="link in sidebarSettings.data.web_pages"
						class="mx-2 my-0.5"
					>
						<SidebarLink
							:link="link"
							:isCollapsed="sidebarStore.isSidebarCollapsed"
							:showControls="isModerator ? true : false"
							@openModal="openPageModal"
							@deletePage="deletePage"
						/>
					</div>
				</div>
			</div>
		</div>
		<div class="m-2 flex flex-col gap-1">
			<div
				v-if="readOnlyMode && !sidebarStore.isSidebarCollapsed"
				class="z-10 m-2 bg-surface-elevation-2 py-2.5 px-3 text-xs text-ink-gray-7 leading-5 rounded-md"
			>
				{{
					__(
						'This site is being updated. You will not be able to make any changes. Full access will be restored shortly.'
					)
				}}
			</div>
			<div
				v-if="
					isStudent && !profileIsComplete && !sidebarStore.isSidebarCollapsed
				"
				class="flex flex-col gap-3 text-ink-gray-9 py-2.5 px-3 bg-surface-base shadow-sm rounded-md"
			>
				<div class="flex flex-col text-p-sm gap-1">
					<div class="inline-flex gap-1">
						<span class="lucide-user h-4 my-0.5 shrink-0" />
						<div class="font-medium">
							{{ __('Complete your profile') }}
						</div>
					</div>
					<div class="text-ink-gray-7 leading-5">
						{{ __('Highlight what makes you unique and show your skills.') }}
					</div>
				</div>
				<router-link
					:to="{
						name: 'Profile',
						params: {
							username: userResource.data?.username,
						},
					}"
				>
					<Button :label="__('My Profile')" class="w-full">
						<template #prefix>
							<span class="lucide-chevrons-right h-4 w-4 text-ink-gray-7" />
						</template>
					</Button>
				</router-link>
			</div>
			<Tooltip
				v-if="
					isStudent && !profileIsComplete && sidebarStore.isSidebarCollapsed
				"
				:text="__('Complete your profile')"
			>
				<router-link
					:to="{
						name: 'Profile',
						params: {
							username: userResource.data?.username,
						},
					}"
					class="flex items-center justify-center"
				>
					<span class="lucide-user size-4 text-ink-gray-7 cursor-pointer" />
				</router-link>
			</Tooltip>
			<TrialBanner
				v-if="
					userResource.data?.is_system_manager && userResource.data?.is_fc_site
				"
				:isSidebarCollapsed="sidebarStore.isSidebarCollapsed"
			/>
			<GettingStartedBanner
				v-if="showOnboarding && !isOnboardingStepsCompleted"
				:isSidebarCollapsed="sidebarStore.isSidebarCollapsed"
				appName="learning"
			/>

			<div
				class="flex items-center mt-4"
				:class="
					sidebarStore.isSidebarCollapsed ? 'flex-col space-y-3' : 'flex-row'
				"
			>
				<div
					class="flex items-center flex-1 gap-3"
					:class="sidebarStore.isSidebarCollapsed ? 'flex-col' : 'flex-row'"
				>
					<Tooltip v-if="readOnlyMode && sidebarStore.isSidebarCollapsed">
						<span
							class="lucide-circle-alert size-4 text-ink-gray-7 cursor-pointer"
						/>
						<template #body>
							<div
								class="max-w-[30ch] rounded bg-surface-gray-10 px-2 py-1 text-center text-p-xs text-ink-base shadow-xl"
							>
								{{
									__(
										'This site is being updated. You will not be able to make any changes. Full access will be restored shortly.'
									)
								}}
							</div>
						</template>
					</Tooltip>
					<Tooltip
						v-if="showAppointmentIcon"
						:text="__('Book a free onboarding session with the Frappe team')"
					>
						<span
							class="lucide-phone size-4 text-ink-gray-7 cursor-pointer"
							@click="redirectToAppointmentScreen()"
						/>
					</Tooltip>
					<Tooltip v-if="showOnboarding" :text="__('Help')">
						<span
							class="lucide-circle-help size-4 text-ink-gray-7 cursor-pointer"
							@click="
								() => {
									showHelpModal = minimize ? true : !showHelpModal
									minimize = !showHelpModal
								}
							"
						/>
					</Tooltip>
					<Tooltip :text="__('Powered by Frappe Learning')">
						<span
							class="lucide-zap size-4 text-ink-gray-7 cursor-pointer"
							@click="redirectToWebsite()"
						/>
					</Tooltip>
				</div>
				<Tooltip
					:text="
						sidebarStore.isSidebarCollapsed ? __('Expand') : __('Collapse')
					"
				>
					<CollapseSidebar
						class="size-4 text-ink-gray-7 duration-300 stroke-1.5 ease-in-out cursor-pointer"
						:style="{
							transform:
								isRtl !== sidebarStore.isSidebarCollapsed
									? 'rotateY(180deg)'
									: '',
						}"
						@click="toggleSidebar()"
					/>
				</Tooltip>
			</div>
		</div>
		<HelpModal
			data-testid="onboarding-help-modal"
			v-if="showOnboarding && showHelpModal"
			v-model="showHelpModal"
			v-model:articles="articles"
			appName="learning"
			title="Frappe Learning"
			:logo="LMSLogo"
			:afterSkip="(step) => capture('onboarding_step_skipped_' + step)"
			:afterSkipAll="() => capture('onboarding_steps_skipped')"
			:afterReset="(step) => capture('onboarding_step_reset_' + step)"
			:afterResetAll="() => capture('onboarding_steps_reset')"
			docsLink="https://docs.frappe.io/learning"
		/>
		<IntermediateStepModal
			v-model="showIntermediateModal"
			:currentStep="currentStep"
		/>
	</div>
	<CommandPalette v-model="settingsStore.isCommandPaletteOpen" />
	<PageModal
		v-model="showPageModal"
		v-model:reloadSidebar="sidebarSettings"
		:page="pageToEdit"
	/>
	<Dialog v-model:open="showPosterModal" size="5xl">
		<template #body-title>
			<div class="text-lg font-semibold text-ink-gray-9">
				{{ projectTitle }}
			</div>
		</template>
		<template #body-content>
			<div
				class="flex h-[80vh] items-center justify-center rounded border bg-surface-white"
			>
				<img
					:src="posterImageUrl"
					:alt="projectTitle"
					class="max-h-full max-w-full object-contain"
				/>
			</div>
		</template>
	</Dialog>
	<Dialog v-model:open="showLicenseModal" size="3xl">
		<template #body-title>
			<div class="whitespace-pre-line text-lg font-semibold text-ink-gray-9">
				{{ licenseTitle }}
			</div>
		</template>
		<template #body-content>
			<table class="w-full border-collapse text-sm text-ink-gray-8">
				<tbody>
					<tr
						v-for="row in licenseRows"
						:key="row.label"
						class="border-b last:border-b-0"
					>
						<th
							class="w-48 bg-surface-gray-1 px-4 py-3 text-start font-medium align-top"
						>
							{{ row.label }}
						</th>
						<td class="whitespace-pre-line px-4 py-3 align-top">
							{{ row.value }}
						</td>
					</tr>
				</tbody>
			</table>
		</template>
	</Dialog>
</template>

<script setup>
import { getSidebarLinks } from '@/utils'
import { usersStore } from '@/stores/user'
import { sessionStore } from '@/stores/session'
import { useSidebar } from '@/stores/sidebar'
import { useSettings } from '@/stores/settings'
import { Button, call, createResource, Dialog, Tooltip, toast } from 'frappe-ui'
import PageModal from '@/components/Modals/PageModal.vue'
import LMSLogo from '@/components/Icons/LMSLogo.vue'
import { useRouter } from 'vue-router'
import {
	ref,
	onMounted,
	inject,
	watch,
	reactive,
	markRaw,
	h,
	onUnmounted,
	computed,
	defineComponent,
} from 'vue'
import {
	BookOpen,
	CircleHelp,
	FolderTree,
	FileText,
	Landmark,
	UserPlus,
	Users,
	BookText,
} from 'lucide-vue-next'
import {
	TrialBanner,
	HelpModal,
	GettingStartedBanner,
	useOnboarding,
	showHelpModal,
	minimize,
	IntermediateStepModal,
	useTelemetry,
} from 'frappe-ui/frappe'
import InviteIcon from '@/components/Icons/InviteIcon.vue'
import UserDropdown from '@/components/Sidebar/UserDropdown.vue'
import CollapseSidebar from '@/components/Icons/CollapseSidebar.vue'
import SidebarLink from '@/components/Sidebar/SidebarLink.vue'
import CommandPalette from '@/components/CommandPalette/CommandPalette.vue'

const { user } = sessionStore()
const { userResource } = usersStore()
let sidebarStore = useSidebar()
const socket = inject('$socket')
const unreadCount = ref(0)
const sidebarLinks = ref(null)
const { capture } = useTelemetry()
const showPageModal = ref(false)
const showPosterModal = ref(false)
const showLicenseModal = ref(false)
const isModerator = ref(false)
const isInstructor = ref(false)
const pageToEdit = ref(null)
const { sidebarSettings, activeTab, isSettingsOpen, programs } = useSettings()
const settingsStore = useSettings()
const showOnboarding = ref(false)
const showIntermediateModal = ref(false)
const currentStep = ref({})
const router = useRouter()
let onboardingDetails
let isOnboardingStepsCompleted = false
const readOnlyMode = window.read_only_mode
const isRtl = document.documentElement.dir === 'rtl'
const iconProps = {
	strokeWidth: 1.5,
	width: 16,
	height: 16,
}
const EuropeanUnionIcon = markRaw(
	defineComponent({
		name: 'EuropeanUnionIcon',
		render() {
			const stars = Array.from({ length: 12 }, (_, index) => {
				const angle = (index * Math.PI) / 6 - Math.PI / 2
				return h('circle', {
					cx: 12 + Math.cos(angle) * 5.1,
					cy: 12 + Math.sin(angle) * 5.1,
					r: 0.8,
					fill: '#ffcc00',
				})
			})

			return h(
				'svg',
				{
					viewBox: '0 0 24 24',
					fill: 'none',
					xmlns: 'http://www.w3.org/2000/svg',
				},
				[
					h('rect', {
						x: 3,
						y: 4,
						width: 18,
						height: 16,
						rx: 2,
						fill: '#003399',
					}),
					...stars,
				]
			)
		},
	})
)
const posterLink = {
	label: 'BG16RFPR001-1.012-0189-C01',
	icon: EuropeanUnionIcon,
	to: 'https://obucheniya.com/bg#',
}

const projectLabel = '\u041f\u0440\u043e\u0435\u043a\u0442'
const projectNumber = 'BG16RFPR001-1.012-0189-C01'
const projectTitle = `${projectLabel} ${projectNumber}`
const posterImageUrl = '/assets/lms/images/Plameli.jpg'
const licenseNumber = 'EDU Base 01.006\n01-006-0213'
const licenseId = '01-006-0213'
const licenseTitle = `\u041b\u0438\u0446\u0435\u043d\u0437 ${licenseNumber}`
const licenseRows = [
	{
		label: '\u0420\u0410\u0417\u0420\u0410\u0411\u041e\u0422\u0427\u0418\u041a',
		value: '\u0410\u0439-\u0422\u0438 \u0421\u0442\u0435\u043f \u041e\u041e\u0414',
	},
	{
		label: '\u0421\u0438\u0441\u0442\u0435\u043c\u0430 \u0437\u0430 \u043e\u0431\u0443\u0447\u0435\u043d\u0438\u044f',
		value: 'EDU Base 01.006',
	},
	{
		label: '\u041b\u0418\u0426\u0415\u041d\u0417',
		value: licenseId,
	},
	{
		label: '\u041b\u0418\u0426\u0415\u041d\u0417\u041e\u041f\u041e\u041b\u0423\u0427\u0410\u0422\u0415\u041b',
		value: '\u041f\u043b\u0430\u043c\u0435\u043b\u0438 \u0444\u0438\u043d\u0430\u043d\u0441 \u0415\u041e\u041e\u0414',
	},
	{
		label: '\u0424\u0438\u043d\u0430\u043d\u0441\u0438\u0440\u0430\u043d\u043e \u043f\u043e \u043f\u0440\u043e\u0435\u043a\u0442',
		value: projectNumber,
	},
]

onMounted(() => {
	setUpOnboarding()
	addKeyboardShortcut()
	updateSidebarLinks()
	socket.on('publish_lms_notifications', (data) => {
		unreadNotifications.reload()
	})
})

const updateSidebarLinksVisibility = () => {
	sidebarSettings.reload(
		{},
		{
			onSuccess(data) {
				Object.keys(data).forEach((key) => {
					if (!parseInt(data[key])) {
						sidebarLinks.value.forEach((link) => {
							link.items = link.items.filter(
								(item) => item.label.toLowerCase().split(' ').join('_') !== key
							)
						})
					}
				})
			},
		}
	)
}

const addKeyboardShortcut = () => {
	window.addEventListener('keydown', (e) => {
		if (
			e.key === 'k' &&
			(e.ctrlKey || e.metaKey) &&
			!e.target.classList.contains('ProseMirror')
		) {
			toggleCommandPalette()
			e.preventDefault()
		}
	})
}

const toggleCommandPalette = () => {
	settingsStore.isCommandPaletteOpen = !settingsStore.isCommandPaletteOpen
}

const unreadNotifications = createResource({
	cache: 'Unread Notifications Count',
	url: 'frappe.client.get_count',
	makeParams(values) {
		return {
			doctype: 'Notification Log',
			filters: {
				for_user: user,
				read: 0,
			},
		}
	},
	onSuccess(data) {
		unreadCount.value = data
		updateUnreadCount()
	},
	auto: user ? true : false,
})

const updateUnreadCount = () => {
	sidebarLinks.value?.forEach((link) => {
		link.items.forEach((item) => {
			if (item.label === 'Notifications') {
				item.count = unreadCount.value || 0
			}
		})
	})
}

const openPageModal = (link) => {
	showPageModal.value = true
	pageToEdit.value = link
}

const deletePage = (link) => {
	call('lms.lms.api.delete_documents', {
		doctype: 'LMS Sidebar Item',
		documents: [link.name],
	}).then(() => {
		sidebarSettings.reload()
		toast.success(__('Page deleted successfully'))
	})
}

const toggleSidebar = () => {
	sidebarStore.isSidebarCollapsed = !sidebarStore.isSidebarCollapsed
	localStorage.setItem(
		'isSidebarCollapsed',
		JSON.stringify(sidebarStore.isSidebarCollapsed)
	)
}

const toggleWebPages = () => {
	sidebarStore.isWebpagesCollapsed = !sidebarStore.isWebpagesCollapsed
	localStorage.setItem(
		'isWebpagesCollapsed',
		JSON.stringify(sidebarStore.isWebpagesCollapsed)
	)
}

const getFirstCourse = async () => {
	let firstCourse = localStorage.getItem('firstCourse')
	if (firstCourse) return firstCourse
	return await call('lms.lms.onboarding.get_first_course')
}

const getFirstBatch = async () => {
	let firstBatch = localStorage.getItem('firstBatch')
	if (firstBatch) return firstBatch
	return await call('lms.lms.onboarding.get_first_batch')
}

const steps = reactive([
	{
		name: 'create_first_course',
		title: __('Create your first course'),
		icon: markRaw(h(BookOpen, iconProps)),
		completed: false,
		onClick: () => {
			minimize.value = true
			router.push({
				name: 'Courses',
			})
		},
	},
	{
		name: 'create_first_chapter',
		title: __('Add your first chapter'),
		icon: markRaw(h(FolderTree, iconProps)),
		completed: false,
		dependsOn: 'create_first_course',
		onClick: async () => {
			minimize.value = true
			let course = await getFirstCourse()
			if (course) {
				router.push({
					name: 'CourseDetail',
					params: { courseName: course },
					hash: '#settings',
				})
			} else {
				router.push({ name: 'Courses', query: { newCourse: '1' } })
			}
		},
	},
	{
		name: 'create_first_lesson',
		title: __('Add your first lesson'),
		icon: markRaw(h(FileText, iconProps)),
		completed: false,
		dependsOn: 'create_first_chapter',
		onClick: async () => {
			minimize.value = true
			let course = await getFirstCourse()
			if (course) {
				router.push({
					name: 'CourseDetail',
					params: { courseName: course },
					hash: '#settings',
				})
			} else {
				router.push({ name: 'Courses', query: { newCourse: '1' } })
			}
		},
	},
	{
		name: 'create_first_quiz',
		title: __('Create your first quiz'),
		icon: markRaw(h(CircleHelp, iconProps)),
		completed: false,
		dependsOn: 'create_first_course',
		onClick: () => {
			minimize.value = true
			router.push({ name: 'Quizzes' })
		},
	},
	{
		name: 'invite_students',
		title: __('Invite your team and students'),
		icon: markRaw(h(InviteIcon, iconProps)),
		completed: false,
		onClick: () => {
			minimize.value = true
			activeTab.value = 'Members'
			isSettingsOpen.value = true
		},
	},
	{
		name: 'create_first_batch',
		title: __('Create your first batch'),
		icon: markRaw(h(Users, iconProps)),
		completed: false,
		onClick: () => {
			minimize.value = true
			router.push({ name: 'Batches' })
		},
	},
	{
		name: 'add_batch_student',
		title: __('Add students to your batch'),
		icon: markRaw(h(UserPlus, iconProps)),
		completed: false,
		dependsOn: 'create_first_batch',
		onClick: async () => {
			minimize.value = true
			let batch = await getFirstBatch()
			if (batch) {
				router.push({
					name: 'Batch',
					params: {
						batchName: batch,
					},
				})
			} else {
				router.push({ name: 'Batch' })
			}
		},
	},
	{
		name: 'add_batch_course',
		title: __('Add courses to your batch'),
		icon: markRaw(h(BookText, iconProps)),
		completed: false,
		dependsOn: 'create_first_batch',
		onClick: async () => {
			minimize.value = true
			let batch = await getFirstBatch()
			if (batch) {
				router.push({
					name: 'Batch',
					params: {
						batchName: batch,
					},
					hash: '#courses',
				})
			} else {
				router.push({ name: 'Batch' })
			}
		},
	},
])

const articles = ref([
	{
		title: __('Introduction'),
		opened: false,
		subArticles: [
			{ name: 'introduction', title: __('Introduction') },
			{ name: 'setting-up', title: __('Setting up') },
		],
	},
	{
		title: __('Creating a course'),
		opened: false,
		subArticles: [
			{ name: 'create-a-course', title: __('Create a course') },
			{ name: 'add-a-chapter', title: __('Add a chapter') },
			{ name: 'add-a-lesson', title: __('Add a lesson') },
		],
	},
	{
		title: __('Creating a batch'),
		opened: false,
		subArticles: [
			{ name: 'create-a-batch', title: __('Create a batch') },
			{ name: 'create-a-live-class', title: __('Create a live class') },
		],
	},
	{
		title: __('Learning Paths'),
		opened: false,
		subArticles: [{ name: 'add-a-program', title: __('Add a program') }],
	},
	{
		title: __('Assessments'),
		opened: false,
		subArticles: [
			{ name: 'quizzes', title: __('Quizzes') },
			{ name: 'assignments', title: __('Assignments') },
		],
	},
	{
		title: __('Certification'),
		opened: false,
		subArticles: [
			{ name: 'issue-a-certificate', title: __('Issue a Certificate') },
			{
				name: 'custom-certificate-templates',
				title: __('Custom Certificate Templates'),
			},
		],
	},
	{
		title: __('Monetization'),
		opened: false,
		subArticles: [
			{
				name: 'setting-up-payment-gateway',
				title: __('Setting up payment gateway'),
			},
		],
	},
	{
		title: __('Settings'),
		opened: false,
		subArticles: [{ name: 'roles', title: __('Roles') }],
	},
])

const setUpOnboarding = () => {
	if (userResource.data?.is_system_manager) {
		onboardingDetails = useOnboarding('learning')
		onboardingDetails.setUp(steps)
		isOnboardingStepsCompleted = onboardingDetails.isOnboardingStepsCompleted
		showOnboarding.value = true
	}
}

watch(userResource, async () => {
	await userResource.promise
	if (userResource.data) {
		isModerator.value = userResource.data.is_moderator
		isInstructor.value = userResource.data.is_instructor
		await programs.reload()
		setUpOnboarding()
	}
	updateSidebarLinks()
})

watch(settingsStore.settings, () => {
	updateSidebarLinks()
})

const updateSidebarLinks = () => {
	sidebarLinks.value = getSidebarLinks()
	updateSidebarLinksVisibility()
	updateUnreadCount()
}

const redirectToWebsite = () => {
	window.open('https://frappe.io/learning', '_blank')
}

const isStudent = computed(() => {
	return userResource.data?.is_student
})

const profileIsComplete = computed(() => {
	return (
		userResource.data?.user_image &&
		userResource.data?.headline &&
		userResource.data?.bio
	)
})

const showAppointmentIcon = computed(() => {
	let isTrialPlan = userResource.data?.site_info?.plan?.is_trial_plan
	let trialEndDate = calculateTrialEndDays(
		userResource.data?.site_info?.trial_end_date
	)
	return (
		userResource.data?.is_system_manager &&
		userResource.data?.is_fc_site &&
		isTrialPlan &&
		trialEndDate > 0
	)
})

const calculateTrialEndDays = (trialEndDate) => {
	if (!trialEndDate) return 0

	trialEndDate = new Date(trialEndDate)
	const today = new Date()
	const diffTime = trialEndDate - today
	const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
	return diffDays
}

const redirectToAppointmentScreen = () => {
	window.open(
		'https://calendar.google.com/calendar/u/0/appointments/schedules/AcZssZ0c7Z3XIpW1WgbeIuktSaoX6qudoYuSdRbIlJty5TW7p4IZaOk5viHQGwTNi6HpNVqzOZOTHcle',
		'_blank'
	)
}

onUnmounted(() => {
	socket.off('publish_lms_notifications')
})
</script>
