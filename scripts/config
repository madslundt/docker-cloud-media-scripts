#!/bin/bash
. "/usr/bin/variables"

check_rclone_cloud () {
	if [[ ! "${rclone_cloud_endpoint}" == *: ]]; then
		printf "\n\n"
		echo "Missing colon (:) in RCLONE_CLOUD_ENDPOINT (${rclone_cloud_endpoint})"
		echo "Run: docker exec -ti <DOCKER_CONTAINER> rclone_setup"
		printf "\n\n"

		exit 02
	fi

	if [ "$(rclone listremotes $rclone_config | grep "${rclone_cloud_endpoint}" | wc -l)" == "0" ]; then
		printf "\n\n"
		echo "RCLONE_CLOUD_ENDPOINT (${rclone_cloud_endpoint}) endpoint has not been created within rclone"
		echo "Run: docker exec -ti <DOCKER_CONTAINER> rclone_setup"
		printf "\n\n"

		exit 02
	fi
}

check_rclone_local () {
	if [ "$(printenv ENCRYPT_MEDIA)" != "0" ]; then
		if [[ ! "${rclone_local_endpoint}" == *: ]]; then
			printf "\n\n"
			echo "Missing colon (:) in RCLONE_LOCAL_ENDPOINT (${rclone_local_endpoint})"
			echo "Run: docker exec -ti <DOCKER_CONTAINER> rclone_setup"
			printf "\n\n"

			exit 02
		fi

		if [ "$(rclone listremotes $rclone_config | grep "${rclone_local_endpoint}" | wc -l)" == "0" ]; then
			printf "\n\n"
			echo "RCLONE_LOCAL_ENDPOINT (${rclone_local_endpoint}) endpoint has not been created within rclone"
			echo "Run: docker exec -ti <DOCKER_CONTAINER> rclone_setup"
			printf "\n\n"

			exit 02
		fi
	fi
}
